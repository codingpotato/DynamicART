//
//  CPMoveToCommand.m
//  DynamicArt
//
//  Created by wangyw on 3/28/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMoveToCommand.h"

#import "CPDrawContext.h"

@implementation CPMoveToCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGPoint currentPosition = drawContext.position;
    if (drawContext.penDown) {
        CGContextRef context = drawContext.context;
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, currentPosition.x, currentPosition.y);
        CGContextAddLineToPoint(context, self.target.x, self.target.y);
        
        CGContextStrokePath(context);        
    }
    
    drawContext.position = self.target;
}

@end
