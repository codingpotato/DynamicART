//
//  CPWaitCommand.m
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWaitCommand.h"

#import "CPDrawContext.h"

@implementation CPWaitCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    [drawContext waitForInterval:self.interval condition:self.condition];
}

@end
