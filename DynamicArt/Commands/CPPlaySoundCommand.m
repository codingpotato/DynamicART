//
//  CPPlaySoundCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/26/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPlaySoundCommand.h"

#import "CPDrawContext.h"

@implementation CPPlaySoundCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    [drawContext playSound:self.frequency timeInterval:self.interval condition:self.condition];
}

@end
