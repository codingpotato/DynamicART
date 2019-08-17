//
//  CPArcCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArcCommand.h"

#import "CPDrawContext.h"

static inline CGFloat radianOfAngle(CGFloat angle) {
    return (angle - 90.0) * M_PI / 180.0;
}

@implementation CPArcCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.x, self.y, self.radius, radianOfAngle(self.startAngle), radianOfAngle(self.endAngle), NO);
    CGContextStrokePath(context);
}

@end
