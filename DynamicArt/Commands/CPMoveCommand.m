//
//  CPForwardCommand.m
//  DynamicArt
//
//  Created by wangyw on 3/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMoveCommand.h"

#import "CPDrawContext.h"

@implementation CPMoveCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    NSAssert(self.direction == 1 || self.direction == -1, @"");
    
    CGPoint currentPosition = drawContext.position;
    CGFloat angle = drawContext.angle * M_PI / 180.0;
    currentPosition.x += self.direction * self.step * sin(angle);
    currentPosition.y -= self.direction * self.step * cos(angle);

    if (drawContext.penDown) {
        CGContextRef context = drawContext.context;
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, drawContext.position.x, drawContext.position.y);
        CGContextAddLineToPoint(context, currentPosition.x, currentPosition.y);
        CGContextStrokePath(context);
    }

    drawContext.position = currentPosition;
}

@end
