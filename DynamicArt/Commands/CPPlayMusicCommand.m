//
//  CPPlayMusicCommand.m
//  DynamicArt
//
//  Created by wangyw on 12/1/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPlayMusicCommand.h"

#import "CPDrawContext.h"

@implementation CPPlayMusicCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    [drawContext playMusic:self.musicString condition:self.condition];
}

@end
