//
//  CPLogViewController.m
//  DynamicArt
//
//  Created by wangyw on 9/22/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLogViewController.h"

#import "CPTrace.h"

@interface CPLogViewController ()

@property (nonatomic) BOOL needRefresh;

@property (strong, nonatomic) NSTimer *timer;

- (void)refresh;

@end

@implementation CPLogViewController

- (void)setLogString:(NSString *)logString {
    _logString = logString;
    _needRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.needRefresh = YES;
    [self refresh];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
    
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    CPTrace(@"%@ dealloc", self);
}

#pragma mark - private methods

- (void)refresh {
    if (self.needRefresh) {
        self.textView.text = self.logString;
        self.needRefresh = NO;
    }
}

@end
