//
//  CPTrashManager.m
//  DynamicArt
//
//  Created by wangyw on 11/26/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTrashManager.h"

#import "CPGeometryHelper.h"

@interface CPTrashManager ()

@property (weak, nonatomic) UIView *trashView;

@property (strong, nonatomic) UIImageView *promptImageview;

- (void)showTrash;

- (void)hideTrash;

- (void)showPrompt;

- (void)hidePrompt;

@end

@implementation CPTrashManager

- (id)initWithTrashView:(UIView *)trashView {
    self = [super init];
    if (self) {
        _trashView = trashView;
    }
    return self;
}

- (void)pickedUpFromBlockView:(UIView *)blockView {
    [self showTrash];
}

- (void)blockViewMoveIntoTrash:(UIView *)blockView location:(CGPoint)location byTranslation:(CGPoint)translation {
    BOOL isLocationInTrash = CGRectContainsPoint(self.trashView.bounds, [blockView convertPoint:CPPointTranslate(location, translation) toView:self.trashView]);
    
    if (isLocationInTrash) {
        [self showPrompt];
    } else {
        [self hidePrompt];
    }
}

- (void)putDownFromBlockView:(UIView *)blockView {
    [self hidePrompt];
    [self hideTrash];
}

- (BOOL)isInRemoveState {
    return self.promptImageview != nil;
}

#pragma mark - private methods

static const CGFloat _trashDuration = 0.25;
static const CGFloat _promptDuration = 1.0;

- (void)showTrash {
    NSAssert(self.trashView.superview, @"");
    
    self.trashView.hidden = NO;
    [UIView animateWithDuration:_trashDuration animations:^{
        self.trashView.center = CGPointMake(self.trashView.superview.bounds.size.width - self.trashView.bounds.size.width / 2, self.trashView.superview.bounds.size.height - self.trashView.bounds.size.height / 2 - 44.0);
    }];
}

- (void)hideTrash {
    NSAssert(self.trashView.superview, @"");
    
    [UIView animateWithDuration:_trashDuration animations:^{
        self.trashView.center = CGPointMake(self.trashView.superview.bounds.size.width + self.trashView.bounds.size.width / 2, self.trashView.superview.bounds.size.height - self.trashView.bounds.size.height / 2 - 44.0);
    } completion:^(BOOL finished) {
        self.trashView.hidden = YES;
    }];
}

- (void)showPrompt {
    NSAssert(self.trashView.superview, @"");

    if (!self.promptImageview) {
        self.promptImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remove_prompt.png"]];
        self.promptImageview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        self.promptImageview.center = CGPointMake(self.trashView.superview.bounds.size.width - self.promptImageview.bounds.size.width / 2, self.trashView.superview.bounds.size.height - 300.0);
        [self.trashView.superview addSubview:self.promptImageview];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = _promptDuration;
        animation.toValue = [NSNumber numberWithFloat:0.8];
        animation.autoreverses = YES;
        animation.repeatCount = HUGE_VALF;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.promptImageview.layer addAnimation:animation forKey:nil];
    }
}

- (void)hidePrompt {
    if (self.promptImageview) {
        [self.promptImageview removeFromSuperview];
        self.promptImageview = nil;
    }
}

@end
