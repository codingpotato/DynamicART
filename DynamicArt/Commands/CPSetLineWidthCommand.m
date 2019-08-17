//
//  CPSetLineWidthCommand.m
//  DynamicArt
//
//  Created by wangyw on 3/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetLineWidthCommand.h"

#import "CPDrawContext.h"

@implementation CPSetLineWidthCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    drawContext.lineWidth = self.lineWidth;
}

@end
