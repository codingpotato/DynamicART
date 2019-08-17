//
//  CPShow.m
//  DynamicArt
//
//  Created by wangyw on 11/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPShow.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPCacheManager.h"
#import "CPShowCommand.h"

typedef enum {
    CPShowSocketNext,
    CPShowNumberOfSockets
} CPShowSockets;

typedef enum {
    CPShowNumberOfArguments
} CPShowArguments;

@implementation CPShow

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPShowNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPShowCommand *command = [[CPShowCommand alloc] init];
    command.shown = YES;
    [self.blockController sendUiCommand:command];
}

@end
