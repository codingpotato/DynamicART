//
//  CPPenCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPenCommand.h"

#import "CPDrawContext.h"

@implementation CPPenCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    drawContext.penDown = self.isPenDown;
}

@end
