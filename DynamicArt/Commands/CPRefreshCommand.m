//
//  CPRefreshCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRefreshCommand.h"

#import "CPDrawContext.h"

@implementation CPRefreshCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    [drawContext refresh];
}

@end
