//
//  CPEllipseCommand.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPEllipseCommand.h"

#import "CPDrawContext.h"

@implementation CPEllipseCommand

@synthesize rect = _rect;

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, self.rect);
    CGContextFillPath(context);

    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, self.rect);
    CGContextStrokePath(context);
}

@end
