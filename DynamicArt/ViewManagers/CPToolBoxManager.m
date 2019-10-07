//
//  CPToolBoxManager.m
//  DynamicArt
//
//  Created by Yongwu Wang on 6/24/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPToolBoxManager.h"

#import "CPGeometryHelper.h"
#import "CPBlockView.h"

#import "CPAdd.h"
#import "CPAddToList.h"
#import "CPAnd.h"
#import "CPArc.h"
#import "CPBeatsPerMinute.h"
#import "CPBreak.h"
#import "CPCast.h"
#import "CPClear.h"
#import "CPClearList.h"
#import "CPColorOfHSBA.h"
#import "CPColorOfRGBA.h"
#import "CPContinue.h"
#import "CPCopyList.h"
#import "CPCurve.h"
#import "CPDay.h"
#import "CPDistance.h"
#import "CPDivide.h"
#import "CPEllipse.h"
#import "CPEqual.h"
#import "CPGoHome.h"
#import "CPGreat.h"
#import "CPGreatAndEqual.h"
#import "CPHeading.h"
#import "CPHide.h"
#import "CPHour.h"
#import "CPIf.h"
#import "CPIfElse.h"
#import "CPInsertAtList.h"
#import "CPJoin.h"
#import "CPJoinList.h"
#import "CPLengthOfList.h"
#import "CPLess.h"
#import "CPLessAndEqual.h"
#import "CPLine.h"
#import "CPListEmpty.h"
#import "CPLog.h"
#import "CPLogList.h"
#import "CPLoopForever.h"
#import "CPLoopFromToStep.h"
#import "CPMathFunction.h"
#import "CPMinute.h"
#import "CPMod.h"
#import "CPMonth.h"
#import "CPMoveBackward.h"
#import "CPMoveForward.h"
#import "CPMoveTo.h"
#import "CPMultiple.h"
#import "CPMyStartup.h"
#import "CPNot.h"
#import "CPNotEqual.h"
#import "CPOr.h"
#import "CPPenDown.h"
#import "CPPenUp.h"
#import "CPPerform.h"
#import "CPPlayMusic.h"
#import "CPPlaySound.h"
#import "CPPoint.h"
#import "CPPointInRect.h"
#import "CPPolygen.h"
#import "CPPower.h"
#import "CPRandom.h"
#import "CPRandomColor.h"
#import "CPRect.h"
#import "CPRefresh.h"
#import "CPRemoveFromList.h"
#import "CPRemoveLastItemOfList.h"
#import "CPRepeat.h"
#import "CPReplaceListWith.h"
#import "CPReturn.h"
#import "CPScreenColor.h"
#import "CPSecond.h"
#import "CPSecondsSince1970.h"
#import "CPSetDashPattern.h"
#import "CPSetFillColor.h"
#import "CPSetFont.h"
#import "CPSetFontSize.h"
#import "CPSetLineColor.h"
#import "CPSetLineJoin.h"
#import "CPSetLineWidth.h"
#import "CPSetVariable.h"
#import "CPShow.h"
#import "CPSplitString.h"
#import "CPStartup.h"
#import "CPSub.h"
#import "CPTurnLeft.h"
#import "CPTurnOffAutoRefresh.h"
#import "CPTurnOnAutoRefresh.h"
#import "CPTurnRight.h"
#import "CPUntil.h"
#import "CPValueOfList.h"
#import "CPWait.h"
#import "CPWaitForTouch.h"
#import "CPWhenTouchBegin.h"
#import "CPWhenTouchEnd.h"
#import "CPWhenTouchMove.h"
#import "CPWhile.h"
#import "CPWriteAtCenter.h"
#import "CPWriteAtOrigin.h"
#import "CPYear.h"

@interface CPToolBoxManager ()

@property (weak, nonatomic) id<CPToolBoxManagerDelegate> delegate;

@property (strong, nonatomic) UIView *currentThumbnailsView;

- (NSDictionary *)blockCategories;

- (NSArray *)categoryTitles;

- (NSMutableDictionary *)images;

- (void)initSegmentedControll;

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture;

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture;

- (void)beginDragThumbnailView:(UIView *)view;

@end

@implementation CPToolBoxManager

static NSDictionary *_blockCategories;

static NSArray *_categoryTitles;

static NSMutableDictionary *_images;

static int _selectedIndexOfblockCategory = 0;

static const CGFloat _toolBoxShowHideDuration = 0.3;

#pragma mark - property methods

- (UIView *)currentThumbnailsView {
    if (!_currentThumbnailsView) {
        CGRect frame = self.toolBoxView.bounds;
        CGFloat inset = 30.0;
        frame.origin.x += inset;
        frame.origin.y += inset;
        frame.size.width -= inset * 2;
        frame.size.height -= inset * 2;
        NSString *categoryName = [self.blockCategoriesSegmentedControl titleForSegmentAtIndex:self.blockCategoriesSegmentedControl.selectedSegmentIndex];
        _currentThumbnailsView = [[UIView alloc] initWithFrame:frame];
        _currentThumbnailsView.backgroundColor = [UIColor clearColor];
        
        CGFloat x = 0.0, y = 0.0, space = 20.0, maxHeight = 0.0;
        NSArray *blocks = [self.blockCategories objectForKey:categoryName];
        int index = 0;
        for (Class class in blocks) {
            UIImage *image = [self.images objectForKey:(id<NSCopying>)class];
            if (!image) {
                image = [self.delegate toolBoxManager:self generateImageForBlockClass:class];
                [self.images setObject:image forKey:(id<NSCopying>)class];
            }
            
            if (x > 0.0 && x + image.size.width >= _currentThumbnailsView.bounds.size.width) {
                x = 0.0;
                y += maxHeight + space;
                maxHeight = 0.0;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);
            imageView.tag = index++;
            imageView.userInteractionEnabled = YES;
            
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
            longPressGestureRecognizer.minimumPressDuration = 0.1;
            longPressGestureRecognizer.delegate = self;
            [imageView addGestureRecognizer:longPressGestureRecognizer];
            UIPanGestureRecognizer *panGestureRecgnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
            panGestureRecgnizer.delegate = self;
            [imageView addGestureRecognizer:panGestureRecgnizer];
            [_currentThumbnailsView addSubview:imageView];
            
            if (image.size.height > maxHeight) {
                maxHeight = image.size.height;
            }
            x += image.size.width + space;
        }
    }
    return _currentThumbnailsView;
}

- (NSDictionary *)blockCategories {
    if (!_blockCategories) {
        NSArray *controlBlocks = [NSArray arrayWithObjects:[CPStartup class], [CPMyStartup class], [CPPerform class], [CPWait class], [CPBreak class], [CPContinue class], [CPReturn class], [CPRepeat class], [CPLoopForever class], [CPLoopFromToStep class], [CPWhile class], [CPUntil class], [CPIf class], [CPIfElse class], nil];
        NSArray *interactionBlocks = [NSArray arrayWithObjects:[CPWhenTouchBegin class], [CPWhenTouchMove class], [CPWhenTouchEnd class], [CPWaitForTouch class], [CPBeatsPerMinute class], [CPPlayMusic class], [CPPlaySound class], [CPLog class], nil];
        NSArray *turtleBlocks = [NSArray arrayWithObjects:[CPGoHome class], [CPPenDown class], [CPPenUp class], [CPShow class], [CPHide class], [CPMoveForward class], [CPMoveBackward class], [CPTurnLeft class], [CPTurnRight class], [CPMoveTo class], [CPHeading class], nil];
        NSArray *paintBlocks = [NSArray arrayWithObjects:[CPPoint class], [CPPolygen class], [CPLine class], [CPRect class], [CPEllipse class], [CPArc class], [CPCurve class], [CPWriteAtCenter class], [CPWriteAtOrigin class], nil];
        NSArray *utilityBlocks = [NSArray arrayWithObjects:[CPScreenColor class], [CPRandomColor class], [CPColorOfRGBA class], [CPColorOfHSBA class], [CPSetLineWidth class], [CPSetLineColor class], [CPSetLineJoin class], [CPSetDashPattern class], [CPSetFillColor class], [CPClear class], [CPSetFont class], [CPSetFontSize class], [CPTurnOnAutoRefresh class], [CPTurnOffAutoRefresh class], [CPRefresh class], nil];
        NSArray *expressionBlocks = [NSArray arrayWithObjects:[CPAdd class], [CPSub class], [CPMultiple class], [CPDivide class], [CPMod class], [CPPower class], [CPMathFunction class], [CPRandom class], [CPYear class], [CPMonth class], [CPDay class], [CPHour class], [CPMinute class], [CPSecond class], [CPSecondsSince1970 class], [CPDistance class], [CPLess class], [CPLessAndEqual class], [CPEqual class], [CPNotEqual class], [CPGreat class], [CPGreatAndEqual class], [CPAnd class], [CPOr class], [CPNot class], [CPPointInRect class], [CPJoin class], nil];
        NSArray *variableBlocks = [NSArray arrayWithObjects:[CPSetVariable class], [CPCast class], [CPAddToList class], [CPInsertAtList class], [CPReplaceListWith class], [CPRemoveFromList class], [CPRemoveLastItemOfList class], [CPClearList class], [CPCopyList class], [CPSplitString class], [CPLogList class], [CPLengthOfList class], [CPValueOfList class], [CPListEmpty class], [CPJoinList class], nil];
        _blockCategories = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:controlBlocks, interactionBlocks, turtleBlocks, paintBlocks, utilityBlocks, expressionBlocks, variableBlocks, nil] forKeys:self.categoryTitles];
        [CPCacheManager addCachedClass:self.class];
    }
    return _blockCategories;
}

- (NSArray *)categoryTitles {
    if (!_categoryTitles) {
        _categoryTitles = [[NSArray alloc] initWithObjects:@"Control", @"Interaction", @"Turtle", @"Paint",  @"Utility", @"Expression", @"Variable", nil];
        [CPCacheManager addCachedClass:self.class];
    }
    return _categoryTitles;
}

- (NSMutableDictionary *)images {
    if (!_images) {
        _images = [[NSMutableDictionary alloc] init];
        [CPCacheManager addCachedClass:self.class];
    }
    return _images;
}

#pragma mark - public methods

- (id)initWithFrame:(CGRect)frame delegate:(id<CPToolBoxManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
        self.view.frame = frame;
        _delegate = delegate;
        
        self.toolBoxView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.toolBoxView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.toolBoxView.layer.shadowOpacity = 0.8;
        [self initSegmentedControll];
        [self.toolBoxView addSubview:self.currentThumbnailsView];
        
        self.toolBoxView.center = CPPointTranslateByY(self.toolBoxView.center, -self.toolBoxView.bounds.size.height);
        [UIView animateWithDuration:_toolBoxShowHideDuration animations:^{
            self.toolBoxView.center = CPPointTranslateByY(self.toolBoxView.center, self.toolBoxView.bounds.size.height);
        } completion:nil];
    }
    return self;
}

- (IBAction)dismissToolBoxManager:(id)sender {
    [UIView animateWithDuration:_toolBoxShowHideDuration animations:^{
        self.toolBoxView.center = CPPointTranslateByY(self.toolBoxView.center, -self.toolBoxView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.delegate dismissToolBoxManager:self];
    }];
}

- (IBAction)blockCategoryChanged:(id)sender {
    [self.currentThumbnailsView removeFromSuperview];
    self.currentThumbnailsView = nil;
    [self.toolBoxView addSubview:self.currentThumbnailsView];
    
    _selectedIndexOfblockCategory = (int)self.blockCategoriesSegmentedControl.selectedSegmentIndex;
}

- (IBAction)tapMask:(id)sender {
    [self dismissToolBoxManager:sender];
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    _blockCategories = nil;
    _categoryTitles = nil;
    _images = nil;
}

#pragma mark - UIGestureRecognizerDelegate implement

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) || ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - private methods

- (void)initSegmentedControll {
    [self.blockCategoriesSegmentedControl removeAllSegments];
    for (NSString *categoryTitle in self.categoryTitles) {
        [self.blockCategoriesSegmentedControl insertSegmentWithTitle:categoryTitle atIndex:self.blockCategoriesSegmentedControl.numberOfSegments animated:NO];
    }
    self.blockCategoriesSegmentedControl.selectedSegmentIndex = _selectedIndexOfblockCategory;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self beginDragThumbnailView:longPressGesture.view];
    } else if (longPressGesture.state == UIGestureRecognizerStateEnded || longPressGesture.state == UIGestureRecognizerStateCancelled || longPressGesture.state == UIGestureRecognizerStateFailed) {
        [self.delegate putDownBlockViewFromToolBoxManager:self];
        self.view.hidden = NO;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateChanged && self.view.hidden == YES) {
        CGPoint location = [panGesture locationInView:self.view];
        CGPoint translation = [panGesture translationInView:self.view];
        [self.delegate toolBoxManager:self moveBlockViewFromLocation:location inView:self.view ByTranslation:translation];
        [panGesture setTranslation:CGPointZero inView:self.view];
    } else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateFailed) {
        [self.delegate putDownBlockViewFromToolBoxManager:self];
        self.view.hidden = NO;
    }
}

- (void)beginDragThumbnailView:(UIView *)view {
    self.view.hidden = YES;
    NSString *categoryName = [self.blockCategoriesSegmentedControl titleForSegmentAtIndex:self.blockCategoriesSegmentedControl.selectedSegmentIndex];
    NSArray *blocks = [self.blockCategories objectForKey:categoryName];
    Class blockClass = [blocks objectAtIndex:view.tag];
    [self.delegate toolBoxManager:self beginDragThumbnailView:view ofBlockClass:blockClass];
}

@end
