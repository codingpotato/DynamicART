//
//  CPStageViewController.m
//  DynamicArt
//
//  Created by wangyw on 4/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPStageViewController.h"

#import "CPApplicationController.h"
#import "CPLogViewController.h"
#import "CPMailBodyParser.h"
#import "CPTrace.h"

#import "CPBlockController.h"
#import "CPCommand.h"
#import "CPConditions.h"
#import "CPNumberValue.h"
#import "CPVariableManager.h"

@interface CPStageViewController ()

@property (nonatomic) BOOL executing;

@property (nonatomic) BOOL needRefresh;

@property (strong, nonatomic) NSCalendar *currentCalender;

@property (weak, nonatomic) CPLogViewController *logViewController;

@property (strong, nonatomic) NSMutableString *logString;

@property (nonatomic) NSUInteger logLineCount;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) CPSynthesizer *synthesizer;

@property (nonatomic) CGContextRef context;

@property (nonatomic) CGSize size;

@property (nonatomic) CGPoint position;

@property (nonatomic) CGFloat angle;

@property (nonatomic) BOOL penDown;

@property (nonatomic) BOOL turtleShown;

@property (strong, nonatomic) UIColor *lineColor;

@property (strong, nonatomic) UIColor *fillColor;

@property (nonatomic) double lineWidth;

@property (nonatomic) CGLineJoin lineJoin;

@property (strong, nonatomic) NSString *fontName;

@property (nonatomic) CGFloat fontSize;

@property (nonatomic) BOOL autoRefresh;

- (void)startExecute;

- (void)stopExecute;

- (void)autoRefreshByTimer;

- (void)signalCondition:(NSCondition *)condition;

@end

@implementation CPStageViewController

/*
 * need defind because of redefine get and set methods
 */
@synthesize lineColor = _lineColor, fillColor = _fillColor;

#pragma mark - property methods

- (NSCalendar *)currentCalender {
    if (!_currentCalender) {
        _currentCalender = [NSCalendar currentCalendar];
    }
    return _currentCalender;
}

- (NSMutableString *)logString {
    if (!_logString) {
        _logString = [[NSMutableString alloc] init];
    }
    return _logString;
}

- (CPSynthesizer *)synthesizer {
    if (!_synthesizer) {
        _synthesizer = [[CPSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

#pragma mark - lifecycle methods

- (void)dealloc {
    CPTrace(@"%@ dealloc", self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startExecute];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.logViewController) {
        [[CPPopoverManager defaultPopoverManager] dismissCurrentPopoverAnimated:NO];
    }
    
    [self stopExecute];
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CPLogSegue"]) {
        [[CPPopoverManager defaultPopoverManager] preparePopoverSegue:segue delegate:self];
        self.logViewController = segue.destinationViewController;
        self.logViewController.logString = self.logString;
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.turtleImageView.center = self.position;
    self.turtleImageView.transform = CGAffineTransformMakeRotation(self.angle * M_PI / 180.0);
    self.size = self.stage.bounds.size;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    if ([keyPath isEqualToString:CPBlockControllerKeyPathUICommand] && blockController.uiCommand) {
        [blockController.uiCommand execute:self];
        self.needRefresh = YES;
    }
}

#pragma mark - public methods

- (IBAction)backBarButtonPressed:(id)sender {
    [self.delegate dismissStageViewController:self animated:YES];
}

- (IBAction)actionBarButtonPressed:(id)sender {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.modalPresentationStyle = UIModalPresentationPopover;
    actionSheet.popoverPresentationController.barButtonItem = self.actionBarButtonItem;
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Save Thumbnail" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        static const CGFloat iconWidth = 160.0;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(iconWidth, iconWidth), YES, self.stage.image.scale);
        
        CGFloat maxWidth = fmax(self.stage.bounds.size.width, self.stage.bounds.size.height);
        CGFloat minWidth = fmin(self.stage.bounds.size.width, self.stage.bounds.size.height);
        CGFloat size = iconWidth * maxWidth / minWidth;
        CGRect rect = CGRectMake(0.0, 0.0, size, size);
        CGFloat top = (size - iconWidth) / 2;
        if (self.stage.bounds.size.height > self.stage.bounds.size.width) {
            rect.origin.y = -top;
        } else {
            rect.origin.x = -top;
        }
        [self.stage.image drawInRect:rect];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[CPApplicationController defaultController] saveThumbnailForCurrentApp:newImage];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Save Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CGRect cropRect = CGRectMake(0.0, 0.0, self.size.width * self.stage.image.scale, self.size.height * self.stage.image.scale);
        CGImageRef cropedCGImage = CGImageCreateWithImageInRect(self.stage.image.CGImage, cropRect);
        UIImage *cropedImage = [UIImage imageWithCGImage:cropedCGImage];
        UIImageWriteToSavedPhotosAlbum(cropedImage, nil, nil, nil);
        CGImageRelease(cropedCGImage);
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIGraphicsBeginImageContext(self.stage.bounds.size);
        [self.stage drawViewHierarchyInRect:self.stage.bounds afterScreenUpdates:NO];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSString *sharedText = @"Shared from Dynamic ART";
        NSURL *sharedURL = [[NSURL alloc] initWithString:@"http://dynamicart.uhostall.com/DynArtFull/"];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[sharedText, image, sharedURL] applicationActivities:nil];
        if ([self respondsToSelector:@selector(popoverPresentationController)]) {
            activityViewController.popoverPresentationController.barButtonItem = self.actionBarButtonItem;
        }
        [self presentViewController:activityViewController animated:YES completion:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)logBarButtonPressed:(id)sender {
    if (self.logViewController) {
        [[CPPopoverManager defaultPopoverManager] dismissCurrentPopoverAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"CPLogSegue" sender:self];
    }
}

#pragma mark - private lifecycle methods

- (void)startExecute {
    if (!self.executing) {
        self.executing = YES;

        CGFloat stageWidth = fmax(self.stage.bounds.size.width, self.stage.bounds.size.height);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(stageWidth, stageWidth), YES, self.stage.image.scale);
        self.context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(self.context, [UIColor blackColor].CGColor);
        CGContextBeginPath(self.context);
        CGContextAddRect(self.context, CGRectMake(0.0, 0.0, stageWidth, stageWidth));
        CGContextFillPath(self.context);
        self.stage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.logString = nil;
        self.logLineCount = 0;
        
        self.size = self.stage.bounds.size;
        self.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        self.angle = 0.0;
        self.penDown = YES;
        self.turtleShown = YES;
        self.lineColor = nil;
        self.fillColor = nil;
        self.lineWidth = 1.0;
        self.lineJoin = kCGLineJoinMiter;
        self.fontName = nil;
        self.fontSize = 20.0;
        self.autoRefresh = YES;
        
        static NSTimeInterval timeInterval = 1.0 / 24;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(autoRefreshByTimer) userInfo:nil repeats:YES];
        
        CPApplicationController *applicationController = [CPApplicationController defaultController];
        [applicationController saveCurrentApp];
        CPBlockController *blockController = applicationController.blockController;
        self.title = blockController.appName;
        [blockController addObserver:self forKeyPath:CPBlockControllerKeyPathUICommand options:NSKeyValueObservingOptionNew context:nil];
        [blockController startExecute];
    }
}

- (void)stopExecute {
    if (self.executing) {
        self.executing = NO;

        // cancel performSelector call for waitInterval
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        [self.timer invalidate];
        self.timer = nil;
        
        [self.synthesizer stop];
        self.synthesizer = nil;
        
        CPBlockController *blockController = [CPApplicationController defaultController].blockController;
        [blockController stopExecute];
        [blockController removeObserver:self forKeyPath:CPBlockControllerKeyPathUICommand];
        
        UIGraphicsEndImageContext();
    }
}

- (void)autoRefreshByTimer {
    if (self.autoRefresh) {
        [self refresh];
    }
}

- (void)signalCondition:(NSCondition *)condition {
    [[CPApplicationController defaultController].blockController.conditions signalCondition:condition];
}

#pragma mark - CPDrawContext implement

- (void)setSize:(CGSize)size {
    _size = size;
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    [blockController.variableManager setValue:[CPNumberValue valueWithDouble:size.width] forVariable:CPBlockControllerVariableScreenWidth];
    [blockController.variableManager setValue:[CPNumberValue valueWithDouble:size.height] forVariable:CPBlockControllerVariableScreenHeight];
}

- (void)setPosition:(CGPoint)position {
    _position = position;
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    [blockController.variableManager setValue:[CPNumberValue valueWithDouble:position.x] forVariable:CPBlockControllerVariableCurrentX];
    [blockController.variableManager setValue:[CPNumberValue valueWithDouble:position.y] forVariable:CPBlockControllerVariableCurrentY];
}

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    [blockController.variableManager setValue:[CPNumberValue valueWithDouble:angle] forVariable:CPBlockControllerVariableCurrentAngle];
}

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    return _lineColor;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    CGContextSetStrokeColorWithColor(self.context, self.lineColor.CGColor);
}

- (UIColor *)fillColor {
    if (!_fillColor) {
        _fillColor = [UIColor clearColor];
    }
    return _fillColor;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    CGContextSetFillColorWithColor(self.context, self.fillColor.CGColor);
}

- (void)setLineWidth:(double)lineWidth {
    _lineWidth = lineWidth;
    CGContextSetLineWidth(self.context, self.lineWidth);
}

- (void)setLineJoin:(CGLineJoin)lineJoin {
    _lineJoin = lineJoin;
    switch (_lineJoin) {
        case kCGLineJoinMiter:
            CGContextSetLineJoin(self.context, kCGLineJoinMiter);
            CGContextSetLineCap(self.context, kCGLineCapButt);
            break;
        case kCGLineJoinRound:
            CGContextSetLineJoin(self.context, kCGLineJoinRound);
            CGContextSetLineCap(self.context, kCGLineCapRound);
            break;
        case kCGLineJoinBevel:
            CGContextSetLineJoin(self.context, kCGLineJoinBevel);
            CGContextSetLineCap(self.context, kCGLineCapButt);
            break;
        default:
            NSAssert(NO, @"");
            break;
    }

}

- (NSString *)fontName {
    if (!_fontName) {
        _fontName = [UIFont systemFontOfSize:self.fontSize].fontName;
    }
    return _fontName;
}

- (void)refresh {
    if (self.needRefresh) {
        self.stage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.turtleImageView.center = self.position;
        self.turtleImageView.transform = CGAffineTransformMakeRotation(self.angle * M_PI / 180.0);
        self.turtleImageView.hidden = !self.turtleShown;
        
        self.needRefresh = NO;
    }
}

- (void)addLog:(NSString *)log {
    self.logLineCount++;
    if (self.logLineCount > 100) {
        NSRange range = [self.logString rangeOfString:@"\n" options:NSBackwardsSearch];
        NSAssert(range.length > 0, @"");
        [self.logString deleteCharactersInRange:NSMakeRange(range.location, self.logString.length - range.location)];
    }
    NSDateComponents *dateComponents = [self.currentCalender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate new]];
    NSString *time = [NSString stringWithFormat:@"%02d/%02d/%04d %02d:%02d:%02d", (int)dateComponents.month, (int)dateComponents.day, (int)dateComponents.year, (int)dateComponents.hour, (int)dateComponents.minute, (int)dateComponents.second];
    [self.logString insertString:[NSString stringWithFormat:@"[%@] %@\n", time, log] atIndex:0];
    if (self.logViewController) {
        self.logViewController.logString = self.logString;
    }
}

- (void)waitForInterval:(NSTimeInterval)interval condition:(NSCondition *)condition {
    [self performSelector:@selector(signalCondition:) withObject:condition afterDelay:interval];
}

- (void)playSound:(float)frequency timeInterval:(NSTimeInterval)interval condition:(NSCondition *)condition {
    [self.synthesizer playSoundByFrequency:frequency timeInterval:interval condition:condition];
}

- (void)setBeatsPerMinute:(float)beatsPerMinute {
    self.synthesizer.beatsPerMinute = beatsPerMinute;
}

- (void)playMusic:(NSString *)musicString condition:(NSCondition *)condition {
    [self.synthesizer playMusic:musicString condition:condition];
}

#pragma mark - CPPopoverManagerDelegate implement

- (void)popoverDismissedFromPopoverManager {
    self.logViewController = nil;
}

#pragma mark - CPStageViewDelegate implement

- (void)stageView:(CPStageView *)stageView beginTouchAt:(CGPoint)touchPoint {
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    [blockController stageBeginTouchAt:touchPoint];
}

- (void)stageView:(CPStageView *)stageView touchMoveTo:(CGPoint)touchPoint from:(CGPoint)previousTouchPoint {
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    [blockController stageTouchMoveTo:touchPoint from:previousTouchPoint];
}

- (void)stageViewEndTouch:(CPStageView *)stageView {
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    [blockController stageTouchEnd];
}

#pragma mark - CPSynthesizerDelegate implement

- (void)synthesizerDidFinishSound:(CPSynthesizer *)synthesizer condition:(NSCondition *)condition {
    [self signalCondition:condition];
}

- (void)synthesizerDidFinishMusic:(CPSynthesizer *)synthesizer condition:(NSCondition *)condition {
    [self signalCondition:condition];
}

#pragma mark - MFMailComposeViewControllerDelegate implement

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
