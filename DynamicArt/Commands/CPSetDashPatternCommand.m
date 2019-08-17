//
//  CPSetDashPatternCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetDashPatternCommand.h"

#import "CPDrawContext.h"

@implementation CPSetDashPatternCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    if (!self.paintLength || !self.unpaintLength) {
        CGContextSetLineDash(drawContext.context, 0.0, NULL, 0);
    } else {
        CGFloat pattern[] = { self.paintLength, self.unpaintLength };
        CGContextSetLineDash(drawContext.context, 0.0, pattern, 2);
    }
}

@end
