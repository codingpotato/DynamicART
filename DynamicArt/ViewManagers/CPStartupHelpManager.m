//
//  CPStartupHelpmanager.m
//  DynamicArt
//
//  Created by wangyw on 10/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPStartupHelpManager.h"

@interface CPStartupHelpManager ()

@property (weak, nonatomic) id<CPStartupHelpManagerDelegate> delegate;

@end

@implementation CPStartupHelpManager

- (id)initWithFrame:(CGRect)frame delegate:(id<CPStartupHelpManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
        _delegate = delegate;
        self.view.frame = frame;
    }
    return self;
}

- (IBAction)doubleTapMask:(id)sender {
    [self.delegate toggleToolbarFromStartupHelpManager:self];
    for (UIView *view in self.toolbarHelpViewCollection) {
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = [self.delegate isToolbarHiddenFromStartupHelpManager:self] ? 0.0 : 1.0;
        }];
    }
}

@end
