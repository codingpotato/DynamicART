//
//  CPBeatsPerMinuteCommand.m
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBeatsPerMinuteCommand.h"

#import "CPDrawContext.h"

@implementation CPBeatsPerMinuteCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    [drawContext setBeatsPerMinute:self.beatsPerMinute];
}

@end
