//
//  CPLineCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLineCommand.h"

#import "CPDrawContext.h"

@implementation CPLineCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.from.x, self.from.y);
    CGContextAddLineToPoint(context, self.to.x, self.to.y);
    CGContextStrokePath(context);
}

@end
