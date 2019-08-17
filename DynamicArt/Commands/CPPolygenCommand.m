//
//  CPDrawPolygenCommand.m
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPolygenCommand.h"

#import "CPDrawContext.h"

@implementation CPPolygenCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);
    for (NSValue *point in self.points) {
        CGContextAddLineToPoint(context, point.CGPointValue.x, point.CGPointValue.y);
    }
    CGContextClosePath(context);
    CGContextFillPath(context);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);
    for (NSValue *point in self.points) {
        CGContextAddLineToPoint(context, point.CGPointValue.x, point.CGPointValue.y);
    }
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

@end
