//
//  CPTurnOffAutoRefresh.m
//  DynamicArt
//
//  Created by wangyw on 11/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTurnOffAutoRefresh.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPCacheManager.h"
#import "CPAutoRefreshCommand.h"

typedef enum {
    CPTurnOffAutoRefreshSocketNext,
    CPTurnOffAutoRefreshNumberOfSockets
} CPTurnOffAutoRefreshSockets;

typedef enum {
    CPTurnOffAutoRefreshNumberOfArguments
} CPTurnOffAutoRefreshArguments;

@implementation CPTurnOffAutoRefresh

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPTurnOffAutoRefreshNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPAutoRefreshCommand *command = [[CPAutoRefreshCommand alloc] init];
    command.on = NO;
    [self.blockController sendUiCommand:command];
}

@end
