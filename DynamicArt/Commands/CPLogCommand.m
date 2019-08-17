//
//  CPLogCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/15/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLogCommand.h"

#import "CPDrawContext.h"

@implementation CPLogCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    [drawContext addLog:self.logString];
}

@end
