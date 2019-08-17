//
//  CPSetColorCommand.m
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetColorCommand.h"

#import "CPDrawContext.h"

@implementation CPSetColorCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    if (self.lineColor) {
        drawContext.lineColor = self.lineColor;
    } else if (self.fillColor) {
        drawContext.fillColor = self.fillColor;
    } else {
        NSAssert(NO, @"");
    }
}

@end
