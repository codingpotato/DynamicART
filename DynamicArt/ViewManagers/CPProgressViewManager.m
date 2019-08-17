//
//  CPProgressViewManager.m
//  DynamicArt
//
//  Created by wangyw on 10/6/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPProgressViewManager.h"

#import "CPImageCache.h"

@interface CPProgressViewManager ()

- (id)initWithParentView:(UIView *)parentView Message:(NSString *)message;

- (void)applicationDidEnterBackground:(NSNotification *)notification;

- (void)done;

@end

@implementation CPProgressViewManager

static CPProgressViewManager *_progressViewManager;

+ (void)showProgressViewWithParentView:(UIView *)parentView Message:(NSString *)message {
    if (!_progressViewManager) {
        _progressViewManager = [[CPProgressViewManager alloc] initWithParentView:parentView Message:message];
    }
}

+ (void)setProgress:(float)progress {
    if (_progressViewManager) {
        [_progressViewManager.progressView setProgress:progress animated:YES];
        if (progress >= 1.0) {
            [_progressViewManager done];
        }
    }
}

- (id)initWithParentView:(UIView *)parentView Message:(NSString *)message {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];        
        self.backgroundImageView.image = [CPImageCache progressBackgroundImage];
        self.messageLabel.text = message;
        self.view.frame = parentView.bounds;
        [parentView addSubview:self.view];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self done];
}

- (void)done {
    [self.view removeFromSuperview];
    _progressViewManager = nil;
}

@end
