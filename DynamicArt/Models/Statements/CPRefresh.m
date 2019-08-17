//
//  CPRefresh.m
//  DynamicArt
//
//  Created by wangyw on 11/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRefresh.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPCacheManager.h"
#import "CPRefreshCommand.h"

typedef enum {
    CPRefreshSocketNext,
    CPRefreshNumberOfSockets
} CPRefreshSockets;

typedef enum {
    CPRefreshNumberOfArguments
} CPRefreshArguments;

@implementation CPRefresh

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPRefreshNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRefreshCommand *command = [[CPRefreshCommand alloc] init];
    [self.blockController sendUiCommand:command];
}

@end
