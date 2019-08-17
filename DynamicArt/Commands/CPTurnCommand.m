//
//  CPTurnLeftCommamd.m
//  DynamicArt
//
//  Created by wangyw on 3/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTurnCommand.h"

#import "CPDrawContext.h"

@implementation CPTurnCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    NSAssert(self.direction == 1 || self.direction == -1, @"");
    
    drawContext.angle += self.direction * self.angle;
    
    int circles = drawContext.angle / 360.0;
    drawContext.angle -= circles * 360.0;
}

@end
