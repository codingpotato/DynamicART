//
//  CPCommand.m
//  DynamicArt
//
//  Created by wangyw on 3/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@implementation CPCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    [self doesNotRecognizeSelector:_cmd];
}

@end
