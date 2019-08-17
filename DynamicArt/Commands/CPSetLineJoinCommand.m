//
//  CPSetLineJoinCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetLineJoinCommand.h"

#import "CPDrawContext.h"

@implementation CPSetLineJoinCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    drawContext.lineJoin = self.lineJoin;
}

@end
