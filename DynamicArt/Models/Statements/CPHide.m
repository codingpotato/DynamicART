//
//  CPHide.m
//  DynamicArt
//
//  Created by wangyw on 11/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPHide.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPCacheManager.h"
#import "CPShowCommand.h"

typedef enum {
    CPHideSocketNext,
    CPHideNumberOfSockets
} CPHideSockets;

typedef enum {
    CPHideNumberOfArguments
} CPHideArguments;

@implementation CPHide

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPHideNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPShowCommand *command = [[CPShowCommand alloc] init];
    command.shown = NO;
    [self.blockController sendUiCommand:command];
}

@end
