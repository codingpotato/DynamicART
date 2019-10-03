//
//  CPFullScreenViewController.m
//  DynamicArt
//
//  Created by wangyw on 8/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPFullScreenViewController.h"

#import "CPInputFieldManager.h"
#import "CPTitleButton.h"

@interface CPFullScreenViewController () <CPTapDetectDelegate>

@property (weak, nonatomic) IBOutlet UIView *statusBarBackground;

@end

@implementation CPFullScreenViewController

static const NSTimeInterval _toolbarShowHideDuration = 0.5;

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.isToolbarHidden;
}

#pragma mark - property methods

- (NSString *)title {
    return [self.titleButton titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title {
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - public methods

- (void)toggleToolbar {
    if (self.isToolbarHidden) {
        [self showToolbar];
    } else {
        [self hideToolbar];
    }
}

- (void)showToolbar {
    if (self.isToolbarHidden) {
        self.isToolbarHidden = NO;
        [UIView animateWithDuration:_toolbarShowHideDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
            self.statusBarBackground.alpha = 1.0;
            self.topToolbar.alpha = 1.0;
            self.bottomToolbar.alpha = 1.0;
        }];
    }
}

- (void)hideToolbar {
    if (!self.isToolbarHidden) {
        self.isToolbarHidden = YES;
        [UIView animateWithDuration:_toolbarShowHideDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
            self.statusBarBackground.alpha = 0.0;
            self.topToolbar.alpha = 0.0;
            self.bottomToolbar.alpha = 0.0;
        }];
    }
}

#pragma mark - CPTapDetectDelegate implement

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    [self toggleToolbar];
}

@end
