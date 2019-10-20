//
//  CPMainViewController.m
//  DynamicArt
//
//  Created by wangyw on 8/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMainViewController.h"

#import "CPApplicationController.h"
#import "CPGeometryHelper.h"
#import "CPImageCache.h"
#import "CPMailBodyParser.h"
#import "CPProgressViewManager.h"
#import "CPTrashManager.h"

#import "CPExpressionView.h"
#import "CPInputField.h"
#import "CPStatementView.h"
#import "CPRightValueStrongTypeArgumentView.h"
#import "CPTitleButton.h"

#import "CPBlockBoard.h"
#import "CPBlockController.h"
#import "CPExpression.h"
#import "CPMyStartupManager.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPStatement.h"
#import "CPVariableManager.h"

@interface CPMainViewController ()

@property (strong, nonatomic) CPStartupHelpManager *startupHelpManager;

@property (strong, nonatomic) CPToolBoxManager *toolBoxManager;

@property (weak, nonatomic) CPStageViewController *stageViewController;

@property (strong, nonatomic) CPTrashManager *trashManager;

@property (nonatomic) CGFloat scrollUpHeight;

@property (strong, nonatomic) UIImageView *ghostImageView;

@property (weak, nonatomic) CPBlockView *draggedBlockView;

@property (strong, nonatomic) UIImageView *connectIndicator;

@property (nonatomic) BOOL isBlockViewsCreated;

@property (nonatomic) BOOL inBlockViewsCreating;

@property (nonatomic) BOOL ignoreBlockViewsCreating;

- (void)applicationDidBecomeActive:(NSNotification *)notification;

- (void)applicationDidEnterBackground:(NSNotification *)notification;

- (void)showStartupHelp;

- (void)hideStartupHelp;

- (void)loadBlockViews;

- (void)unloadBlockViews;

- (void)createViewsForBlockController:(CPBlockController *)blockController;

- (void)removeViewsForBlockController:(CPBlockController *)blockController;

- (CPBlockView *)createViewForBlock:(CPBlock *)block;

- (void)addConnectIndicator;

- (void)removeConnectIndicator;

@end

@implementation CPMainViewController

#pragma mark - property methods

- (CPTrashManager *)trashManager {
    if (!_trashManager) {
        _trashManager = [[CPTrashManager alloc] initWithTrashView:self.trashImageView];
    }
    return _trashManager;
}

#pragma mark - lifecycle methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blockBoard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"block_board_bg.jpg"]];
    if ([UIApplication sharedApplication].keyWindow) {
        [self loadBlockViews];
    }
}

- (void)didReceiveMemoryWarning {
    if (self.isViewLoaded && !self.view.window) {
        // unload views when this view controller is not on the top
        [self unloadBlockViews];
        self.view = nil;
        self.trashManager = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CPApplicationsSegue"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        CPApplicationsViewController *applicationsViewController = (CPApplicationsViewController *)navigationController.topViewController;
        applicationsViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"CPStageSegue"]) {
        self.stageViewController = (CPStageViewController *)segue.destinationViewController;
        self.stageViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"CPHelpSegue"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        CPHelpViewController *helpViewController = (CPHelpViewController *)navigationController.topViewController;
        helpViewController.delegate = self;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (keyPath == CPApplicationControllerKeyPathBlockController) {
        NSLog(@"observer: %@, %@", object, keyPath);
        CPBlockController *oldBlockController = [change objectForKey:NSKeyValueChangeOldKey];
        CPBlockController *newBlockController = [change objectForKey:NSKeyValueChangeNewKey];
        if (![oldBlockController isMemberOfClass:[NSNull class]] && self.isBlockViewsCreated) {
            [self removeViewsForBlockController:oldBlockController];
        }
        if (![newBlockController isMemberOfClass:[NSNull class]]) {
            [self createViewsForBlockController:newBlockController];
        } else {
            [self showStartupHelp];
        }
    } else if (keyPath == CPBlockControllerKeyPathAppName) {
        self.title = [CPApplicationController defaultController].blockController.appName;
    } else if (keyPath == CPBlockControllerKeyPathOffset) {
        self.blockBoard.contentOffset = [CPApplicationController defaultController].blockController.offset;
    } else if (keyPath == CPBlockControllerKeyPathSize) {
        self.blockBoard.contentSize =  [CPApplicationController defaultController].blockController.size;
    } else if (keyPath == CPBlockControllerKeyPathPlugAndSocketConnected) {
        if ( [CPApplicationController defaultController].blockController.plugAndSocketConnected) {
            [self addConnectIndicator];
        } else {
            [self removeConnectIndicator];
        }
    }
}

- (IBAction)toolBoxBarButtonPressed:(id)sender {
    self.navigationController.navigationBar.alpha = 0.0;
    self.navigationController.toolbar.alpha = 0.0;
    self.toolBoxManager = [[CPToolBoxManager alloc] initWithFrame:self.view.bounds delegate:self];
    [self.view insertSubview:self.toolBoxManager.view aboveSubview:self.topToolbar];
}

- (IBAction)titleButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"CPApplicationsSegue" sender:self];
    [self.titleButton arrowUp];
    
    if (![CPApplicationController defaultController].blockController) {
        [self hideStartupHelp];
    }
}

- (IBAction)runBarButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"CPStageSegue" sender:self];
}

- (IBAction)helpBarButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"CPHelpSegue" sender:self];
}

- (IBAction)alignBarButtonPressed:(id)sender {
    [[CPApplicationController defaultController].blockController alignBlocks];
    self.blockBoard.contentOffset = CGPointZero;
}

- (IBAction)airDropBarButtonPressed:(id)sender {
    CPApplicationController *applicationController = [CPApplicationController defaultController];
    CPMailBodyParser *parser = [[CPMailBodyParser alloc] initWithBlockController:applicationController.blockController thumbnailImage:applicationController.thumbnailOfCurrrentApp];
    
    NSURL *url = [[NSURL alloc] initWithString:parser.urlString];
    [UIPasteboard generalPasteboard].string = parser.urlString;
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard,UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    if ([self respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.barButtonItem = sender;
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)mailBarButtonPressed:(id)sender {
    CPApplicationController *applicationController = [CPApplicationController defaultController];
    CPMailBodyParser *parser = [[CPMailBodyParser alloc] initWithBlockController:applicationController.blockController thumbnailImage:applicationController.thumbnailOfCurrrentApp];
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    mailComposeViewController.subject = applicationController.blockController.appName;
    [mailComposeViewController setMessageBody:parser.mailBody isHTML:YES];
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}

#pragma mark - private lifecycle methods

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (![CPApplicationController observerAdded]) {
        CPApplicationController *applicationController = [CPApplicationController defaultController];
        [applicationController addObserver:self forKeyPath:CPApplicationControllerKeyPathBlockController options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        [CPApplicationController setObserverAdded:YES];
    }
    [self loadBlockViews];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self dismissToolBoxManager:nil];
    [self unloadBlockViews];
    
    CPApplicationController *applicationController = [CPApplicationController defaultController];
    [applicationController removeObserver:self forKeyPath:CPApplicationControllerKeyPathBlockController];
    [CPApplicationController releaseDefaultController];
    [CPApplicationController setObserverAdded:NO];
}

- (void)showStartupHelp {
    if (!self.startupHelpManager) {
        self.startupHelpManager = [[CPStartupHelpManager alloc] initWithFrame:self.view.bounds delegate:self
                                   ];
        [self.view insertSubview:self.startupHelpManager.view aboveSubview:self.blockBoard];
        self.title = @"Untitled";
        self.toolBoxBarButtonItem.enabled = NO;
        self.runBarButtonItem.enabled = NO;
        self.alignBarButtonItem.enabled = NO;
        self.airDropBarButtonItem.enabled = NO;
        self.mailBarButtonItem.enabled = NO;

        CGSize blockBoardSize = self.blockBoard.bounds.size;
        CGFloat pageSize = fmax(blockBoardSize.width, blockBoardSize.height);
        self.blockBoard.contentOffset = CGPointMake((pageSize - blockBoardSize.width) / 2, (pageSize - blockBoardSize.height) / 2);
    }
}

- (void)hideStartupHelp {
    if (self.startupHelpManager) {
        self.toolBoxBarButtonItem.enabled = YES;
        self.runBarButtonItem.enabled = YES;
        self.alignBarButtonItem.enabled = YES;
        self.airDropBarButtonItem.enabled = YES;
        self.mailBarButtonItem.enabled = YES;
        [self.startupHelpManager.view removeFromSuperview];
        self.startupHelpManager = nil;
    }
}

- (void)loadBlockViews {
    if (!self.isBlockViewsCreated) {
        [CPInputFieldManager defaultInputFieldManager].delegate = self;

        CPApplicationController *applicationController = [CPApplicationController defaultController];
        CPBlockController *blockController = applicationController.blockController;
        if (blockController) {
            [self createViewsForBlockController:blockController];
        } else if (!applicationController.isLoadingFromUrl) {
            [self showStartupHelp];
        }
        self.isBlockViewsCreated = YES;
    }
}

- (void)unloadBlockViews {
    if (self.isBlockViewsCreated) {
        [CPInputFieldManager defaultInputFieldManager].delegate = nil;

        CPBlockController *blockController = [CPApplicationController defaultController].blockController;
        if (blockController) {
            [self removeViewsForBlockController:blockController];
        }
        self.isBlockViewsCreated = NO;
    }
}

- (void)createViewsForBlockController:(CPBlockController *)blockController {
    NSAssert(blockController, @"");
    
    [blockController addObserver:self forKeyPath:CPBlockControllerKeyPathAppName options:NSKeyValueObservingOptionNew context:nil];
    [blockController addObserver:self forKeyPath:CPBlockControllerKeyPathOffset options:NSKeyValueObservingOptionNew context:nil];
    [blockController addObserver:self forKeyPath:CPBlockControllerKeyPathSize options:NSKeyValueObservingOptionNew context:nil];
    [blockController addObserver:self forKeyPath:CPBlockControllerKeyPathPlugAndSocketConnected options:NSKeyValueObservingOptionNew context:nil];
    
    [self hideStartupHelp];
    self.title = blockController.appName;
    self.blockBoard.contentOffset = blockController.offset;
    self.blockBoard.contentSize = blockController.size;

    if (blockController.blocks.count > 10) {
        NSString *message = [[NSString alloc] initWithFormat:@"Load \"%@\" ......", blockController.appName];
        [CPProgressViewManager showProgressViewWithParentView:self.view Message:message];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.inBlockViewsCreating = YES;
        int blockCount = (int)blockController.blocks.count;
        __block int index = 1;
        [blockController deepTraversePerformBlock:^(CPBlock *block) {
            if (!self.ignoreBlockViewsCreating) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (!self.ignoreBlockViewsCreating) {
                        CPBlockView *blockView = [self createViewForBlock:block];
                        [self.blockBoard addSubview:blockView];
                        [CPProgressViewManager setProgress:(float)index / blockCount];
                    }
                });
                index++;
            }
        }];
        self.ignoreBlockViewsCreating = NO;
        self.inBlockViewsCreating = NO;
    });
}

- (void)removeViewsForBlockController:(CPBlockController *)blockController {
    NSAssert(blockController, @"");
    
    if (self.inBlockViewsCreating) {
        // avoid continue creating block views in another thread
        self.ignoreBlockViewsCreating = YES;
    }
    for (UIView *view in self.blockBoard.subviews) {
        if ([view isKindOfClass:[CPBlockView class]]) {
            [((CPBlockView *)view) remove];
        }
    }
    [blockController removeObserver:self forKeyPath:CPBlockControllerKeyPathAppName];
    [blockController removeObserver:self forKeyPath:CPBlockControllerKeyPathOffset];
    [blockController removeObserver:self forKeyPath:CPBlockControllerKeyPathSize];
    [blockController removeObserver:self forKeyPath:CPBlockControllerKeyPathPlugAndSocketConnected];
}

- (CPBlockView *)createViewForBlock:(CPBlock *)block {
    NSAssert(block, @"");
    
    CPBlockView *blockView;
    if ([block isKindOfClass:[CPExpression class]]) {
        blockView = [[CPExpressionView alloc] initWithBlock:block delegate:self];
    } else if ([block isKindOfClass:[CPStatement class]]) {
        blockView = [[CPStatementView alloc] initWithBlock:block delegate:self];
    } else {
        NSAssert(NO, @"");
    }
    return blockView;
}

- (void)addConnectIndicator {
    if (!self.connectIndicator) {
        self.connectIndicator = [[UIImageView alloc] initWithImage:[CPImageCache connectIndicatorImage]];
        [self.blockBoard addSubview:self.connectIndicator];
    }
    self.connectIndicator.frame =  [CPApplicationController defaultController].blockController.frameOfConnectIndicator;
}

- (void)removeConnectIndicator {
    if (self.connectIndicator) {
        [self.connectIndicator removeFromSuperview];
        self.connectIndicator = nil;
    }
}

#pragma mark - CPApplicationsViewControllerDelegate

- (void)applicationsViewControllerDismissed:(CPApplicationsViewController *)vc {
    [self.titleButton arrowDown];
}

#pragma mark - CPBlockViewDelegate implement

- (void)pickUpFromBlockView:(CPBlockView *)blockView {
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(blockView.bounds.size, NO, blockView.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [blockView.layer renderInContext:context];
    UIImage *blockImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect frame = [self.blockBoard convertRect:blockView.frame toView:self.view];
    self.ghostImageView = [[UIImageView alloc] initWithImage:blockImage];
    self.ghostImageView.frame = frame;
    self.ghostImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.ghostImageView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    self.ghostImageView.layer.shadowOpacity = 0.8;
    [self.view addSubview:self.ghostImageView];
    
    self.draggedBlockView = blockView;
    self.draggedBlockView.hidden = YES;
    [[CPApplicationController defaultController].blockController pickUpBlocksFrom:blockView.block];

    [self.trashManager pickedUpFromBlockView:blockView];
}

- (void)moveFromBlockView:(CPBlockView *)blockView location:(CGPoint)location byTranslation:(CGPoint)translation {
    self.ghostImageView.frame = CGRectOffset(self.ghostImageView.frame, translation.x, translation.y);
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    [blockController moveBlocksFrom:blockView.block byTranslation:translation];
    
    [self.trashManager blockViewMoveIntoTrash:blockView location:location byTranslation:translation];
    if (self.trashManager.isInRemoveState) {
        [blockController disconnectCurrentPlugAndSocket];
        [blockController disconnectCurrentArgumentAndExpression];
    }
}

- (void)putDownFromBlockView:(CPBlockView *)blockView {
    for (CPBlockView *blockView in self.ghostImageView.subviews) {
        [blockView removeFromSuperview];
        [self.blockBoard addSubview:blockView];
    }
    self.draggedBlockView.hidden = NO;
    self.draggedBlockView = nil;
    
    [self.ghostImageView removeFromSuperview];
    self.ghostImageView = nil;
    
    if (self.trashManager.isInRemoveState) {
        [[CPApplicationController defaultController].blockController removeBlocksFrom:blockView.block];
    } else {
        [[CPApplicationController defaultController].blockController putDownBlocksFrom:blockView.block];
    }
    
    [self.trashManager putDownFromBlockView:blockView];
}

- (void)ghostBlockView:(CPBlockView *)blockView {
    if (self.ghostImageView && blockView != self.draggedBlockView) {
        if (blockView.frame.origin.y < self.draggedBlockView.frame.origin.y + self.draggedBlockView.frame.size.height + self.blockBoard.bounds.size.height) {
            CGRect blockFrame = [blockView convertRect:blockView.bounds toView:self.ghostImageView];
            [blockView removeFromSuperview];
            blockView.frame = blockFrame;
            [self.ghostImageView addSubview:blockView];
        }
    }
}

#pragma mark - CPHelpViewControllerDelegate implement

- (void)backFromHelpViewController:(CPHelpViewController *)helpViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CPInputFieldManagerDelegate

- (void)inputFieldManager:(CPInputFieldManager *)inputFieldManager didShowInputField:(CPInputField *)inputField {
    NSAssert(inputField, @"");
    
    CGRect frame = [inputField.view convertRect:inputField.view.bounds toView:self.view];
    CGFloat keyboardHeight = self.view.bounds.size.height > self.view.bounds.size.width ? 500.0 : 600.0;
    if (frame.origin.y + frame.size.height > self.view.bounds.size.height - keyboardHeight) {
        self.scrollUpHeight = keyboardHeight - (self.view.bounds.size.height - frame.origin.y - frame.size.height);
        [self.blockBoard setContentOffset:CPPointTranslateByY(self.blockBoard.contentOffset, self.scrollUpHeight) animated:NO];
        frame.origin.y -= self.scrollUpHeight;
    } else {
        self.scrollUpHeight = 0.0;
    }

    self.blockBoard.scrollEnabled = NO;
    [[CPPopoverManager defaultPopoverManager] presentAutoCompleteViewConrollerfromViewController:self rect:frame inView:self.view];
}

- (void)inputFieldManager:(CPInputFieldManager *)inputFieldManager willHideInputField:(CPInputField *)inputField {
    self.blockBoard.scrollEnabled = YES;
        
    if (self.scrollUpHeight > 0.0) {
        [self.blockBoard setContentOffset:CPPointTranslateByY(self.blockBoard.contentOffset, -self.scrollUpHeight) animated:NO];
        self.scrollUpHeight = 0.0;
    }
    [[CPPopoverManager defaultPopoverManager] dismissCurrentPopoverAnimated:YES];
}

#pragma mark - CPStageViewControllerDelegate implement

- (void)dismissStageViewController:(CPStageViewController *)stageViewController animated:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:nil];
    self.stageViewController = nil;
}

#pragma mark - CPStartupHelpManagerDelegate implement

- (BOOL)isToolbarHiddenFromStartupHelpManager:(CPStartupHelpManager *)startupHelpManager {
    return self.isToolbarHidden;
}

- (void)toggleToolbarFromStartupHelpManager:(CPStartupHelpManager *)startupHelpManager {
    [self toggleToolbar];
}

#pragma mark - CPToolBoxManagerDelegate implement

- (UIImage *)toolBoxManager:(CPToolBoxManager *)toolBoxManager generateImageForBlockClass:(Class)blockClass {
    NSAssert([CPApplicationController defaultController].blockController, @"");
    
    CPBlockController *blockController = [CPApplicationController defaultController].blockController;
    blockController.variableManager.useDefaultVariableName = YES;
    blockController.myStartupManager.useDefaultStartupName = YES;
    CPBlock *block = [blockController createBlockOfClass:blockClass atOrigin:CGPointZero];
    blockController.variableManager.useDefaultVariableName = NO;
    blockController.myStartupManager.useDefaultStartupName = NO;
    
    CPBlockView *blockView = [self createViewForBlock:block];
    UIGraphicsBeginImageContextWithOptions(blockView.bounds.size, NO, blockView.scale);
    [blockView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[CPApplicationController defaultController].blockController removeBlocksFrom:block];
   
    /*
     * non product code, save image to Documents directory, used for generating help images
     */
#if 0
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSStringFromClass(blockClass) stringByAppendingPathExtension:@"png"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (UIView *view in blockView.subviews) {
        if ([view isKindOfClass:[CPRightValueStrongTypeArgumentView class]]) {
            CPRightValueStrongTypeArgumentView *argumentView = (CPRightValueStrongTypeArgumentView *)view;
            CPRightValueStrongTypeArgument *argument = (CPRightValueStrongTypeArgument *)argumentView.argument;
            fileName = [NSStringFromClass(argument.valueClass) stringByAppendingPathExtension:@"png"];
            filePath = [documentsPath stringByAppendingPathComponent:fileName];
            if (![fileManager fileExistsAtPath:filePath]) {
                UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, blockView.scale);
                [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *argumentImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                imageData = UIImagePNGRepresentation(argumentImage);
                [imageData writeToFile:filePath atomically:YES];
            }
        }
    }
#endif
    
    return image;
}

- (void)toolBoxManager:(CPToolBoxManager *)toolBoxManager beginDragThumbnailView:(UIView *)view ofBlockClass:(Class)blockClass {
    CGPoint origin = [view convertPoint:view.bounds.origin toView:self.blockBoard];
    CPBlock *block = [[CPApplicationController defaultController].blockController createBlockOfClass:blockClass atOrigin:origin];
    CPBlockView *blockView = [self createViewForBlock:block];
    [self.blockBoard addSubview:blockView];
    [self pickUpFromBlockView:blockView];
}

- (void)toolBoxManager:(CPToolBoxManager *)toolBoxManager moveBlockViewFromLocation:(CGPoint)location inView:(UIView *)view ByTranslation:(CGPoint)translation {
    location = [view convertPoint:location toView:self.draggedBlockView];
    [self moveFromBlockView:self.draggedBlockView location:location byTranslation:translation];
}

- (void)putDownBlockViewFromToolBoxManager:(CPToolBoxManager *)toolBoxManager {
    [self putDownFromBlockView:self.draggedBlockView];
}

- (void)dismissToolBoxManager:(CPToolBoxManager *)toolBoxManager {
    [self.toolBoxManager.view removeFromSuperview];
    self.toolBoxManager = nil;
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.toolbar.alpha = 1.0;
}

#pragma mark - MFMailComposeViewControllerDelegate implement

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate implement

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [CPApplicationController defaultController].blockController.offset = scrollView.contentOffset;
}

@end
