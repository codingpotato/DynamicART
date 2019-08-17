//
//  CPGoHomeCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/27/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPGoHomeCommand.h"

#import "CPDrawContext.h"

@implementation CPGoHomeCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGPoint center = CGPointMake(drawContext.size.width / 2, drawContext.size.height / 2);
    if (drawContext.penDown) {
        CGPoint currentPosition = drawContext.position;
        CGContextRef context = drawContext.context;
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, currentPosition.x, currentPosition.y);
        CGContextAddLineToPoint(context, center.x, center.y);
        
        CGContextStrokePath(context);        
    }
    drawContext.position = center;
    drawContext.angle = 0.0;
}

@end
