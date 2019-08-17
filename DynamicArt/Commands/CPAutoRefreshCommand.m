//
//  CPAutoRefreshCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPAutoRefreshCommand.h"

#import "CPDrawContext.h"

@implementation CPAutoRefreshCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    drawContext.autoRefresh = self.on;
}

@end
