//
//  CPSetFontCommand.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetFontCommand.h"

#import "CPDrawContext.h"

@implementation CPSetFontCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    drawContext.fontName = self.name;
}

@end
