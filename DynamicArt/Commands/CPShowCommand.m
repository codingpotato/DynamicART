//
//  CPShowCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPShowCommand.h"

#import "CPDrawContext.h"

@implementation CPShowCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    drawContext.turtleShown = self.isShown;
}

@end
