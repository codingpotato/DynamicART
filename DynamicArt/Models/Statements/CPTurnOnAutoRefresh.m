//
//  CPTurnOnAutoRefresh.m
//  DynamicArt
//
//  Created by wangyw on 11/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTurnOnAutoRefresh.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPCacheManager.h"
#import "CPAutoRefreshCommand.h"

typedef enum {
    CPTurnOnAutoRefreshSocketNext,
    CPTurnOnAutoRefreshNumberOfSockets
} CPTurnOnAutoRefreshSockets;

typedef enum {
    CPTurnOnAutoRefreshNumberOfArguments
} CPTurnOnAutoRefreshArguments;

@implementation CPTurnOnAutoRefresh

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPTurnOnAutoRefreshNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPAutoRefreshCommand *command = [[CPAutoRefreshCommand alloc] init];
    command.on = YES;
    [self.blockController sendUiCommand:command];
}

@end
