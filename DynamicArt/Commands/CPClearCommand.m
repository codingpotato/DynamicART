//
//  CPClearCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPClearCommand.h"

#import "CPDrawContext.h"

@implementation CPClearCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    CGFloat clearSize = drawContext.size.width > drawContext.size.height ? drawContext.size.width : drawContext.size.height;

    CGContextSaveGState(drawContext.context);
    
    CGContextSetFillColorWithColor(drawContext.context, [self.color CGColor]);
    CGContextBeginPath(context);
    CGContextAddRect(context, CGRectMake(0.0, 0.0, clearSize, clearSize));
    CGContextFillPath(context);
    
    CGContextRestoreGState(drawContext.context);
}

@end
