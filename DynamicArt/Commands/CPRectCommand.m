//
//  CPRectangleCommand.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRectCommand.h"

#import "CPDrawContext.h"

@implementation CPRectCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    
    CGContextBeginPath(context);
    CGContextAddRect(context, self.rect);
    CGContextFillPath(context);

    CGContextBeginPath(context);
    CGContextAddRect(context, self.rect);
    CGContextStrokePath(context);
}

@end
