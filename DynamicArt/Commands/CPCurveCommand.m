//
//  CPCurveCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCurveCommand.h"

#import "CPDrawContext.h"

@implementation CPCurveCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.point1.x, self.point1.y);
    CGContextAddCurveToPoint(context, self.controlPoint1.x, self.controlPoint1.y, self.controlPoint2.x, self.controlPoint2.y, self.point2.x, self.point2.y);
    CGContextStrokePath(context);
}

@end
