//
//  CPSetFontSizeCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetFontSizeCommand.h"

#import "CPDrawContext.h"

@implementation CPSetFontSizeCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    drawContext.fontSize = self.size;
}

@end
