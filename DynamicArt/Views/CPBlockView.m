//
//  CPBlockView.m
//  DynamicArt
//
//  Created by wangyw on 4/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlockView.h"

#import "CPArgumentView.h"
#import "CPBlockViewDelegate.h"
#import "CPInputField.h"

#import "CPBlock.h"
#import "CPBlockController.h"
#import "CPListArgument.h"
#import "CPPromptArgument.h"
#import "CPRightValueStrongTypeArgument.h"

@interface CPBlockView ()

- (void)createArgumentViews;

@end

@implementation CPBlockView

- (id)initWithBlock:(CPBlock *)block delegate:(id<CPBlockViewDelegate>)delegatge {
    self = [super init];
    if (self) {
        NSAssert(block, @"");
        _delegate = delegatge;
        _block = block;
        self.frame = _block.frame;
        [_block addObserver:self forKeyPath:CPBlockKeyPathFrame options:NSKeyValueObservingOptionNew context:nil];    
        [_block addObserver:self forKeyPath:CPBlockKeyPathPickedUp options:NSKeyValueObservingOptionNew context:nil];
        [_block addObserver:self forKeyPath:CPBlockKeyPathRemoved options:NSKeyValueObservingOptionNew context:nil];
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        longPressGestureRecognizer.minimumPressDuration = 0.2;
        longPressGestureRecognizer.delegate = self;
        [self addGestureRecognizer:longPressGestureRecognizer];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];

        [self createArgumentViews];
    }
    return self;
}

- (CGFloat)scale {
    [self doesNotRecognizeSelector:_cmd];
    return 0.0;
}

- (void)remove {
    [self.block removeObserver:self forKeyPath:CPBlockKeyPathFrame];
    [self.block removeObserver:self forKeyPath:CPBlockKeyPathPickedUp];
    [self.block removeObserver:self forKeyPath:CPBlockKeyPathRemoved];
    for (UIView *view in self.subviews) {
        if ([view conformsToProtocol:@protocol(CPArgumentView)]) {
            [((id<CPArgumentView>)view) removeObservers];
        }
    }
    [self removeFromSuperview];

}

- (void)adjustFrame {
    self.frame = self.block.frame;
    for (UIView *view in self.subviews) {
        if ([view conformsToProtocol:@protocol(CPArgumentView)]) {
            [((id<CPArgumentView>)view) adjustFrame];
        }
    }
}

#pragma mark - observer methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:CPBlockKeyPathFrame]) {
        if (!self.block.isPickedUp) {
            [self adjustFrame];
        }
    }
    if ([keyPath isEqualToString:CPBlockKeyPathPickedUp]) {
        if (self.block.isPickedUp) {
            [self.delegate ghostBlockView:self];
        } else {
            [self adjustFrame];
            [self.superview bringSubviewToFront:self];
        }
    } else if ([keyPath isEqualToString:CPBlockKeyPathRemoved]) {
        [self remove];
    }
}

#pragma mark - gesture handlers

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if (!self.block.isPickedUp) {
            [self.delegate pickUpFromBlockView:self];
        }
    } else if (longPressGesture.state == UIGestureRecognizerStateEnded || longPressGesture.state == UIGestureRecognizerStateCancelled || longPressGesture.state == UIGestureRecognizerStateFailed) {
        if (self.block.isPickedUp) {
            [self.delegate putDownFromBlockView:self];
        }
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:self];
        if (self.block.isPickedUp) {
            CGPoint location = [panGesture locationInView:self];
            [self.delegate moveFromBlockView:self location:location byTranslation:translation];
        }
        [panGesture setTranslation:CGPointZero inView:self];
    } else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateFailed) {
        if (self.block.isPickedUp) {
            [self.delegate putDownFromBlockView:self];
        }
    }
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

- (void)createArgumentViews {
    for (CPArgument *argument in self.block.displayOrderArguments) {
        NSString *className = nil;
        if ([argument isKindOfClass:[CPListArgument class]]) {
            className = @"CPListArgumentView";
        } else {
            className = [NSString stringWithFormat:@"%@View", NSStringFromClass([argument class])];
        }
        Class viewClass = NSClassFromString(className);
        NSAssert1(viewClass, @"should find class for %@", className);
        
        id<CPArgumentView> argumentView = [[viewClass alloc] initWithArgument:argument];
        [self addSubview:(UIView *)argumentView];
    }
}

@end
