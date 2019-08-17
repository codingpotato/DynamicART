//
//  CPLogList.m
//  DynamicArt
//
//  Created by wangyw on 11/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLogList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPLogCommand.h"
#import "CPNullValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPLogListNext,
    CPLogListNumberOfSockets
} CPLogListSockets;

typedef enum {
    CPLogListArgumentList,
    CPLogListNumberOfArguments
} CPLogListArguments;

@implementation CPLogList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPLogListNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPArrayArgument *arrayArgument = [self.syntaxOrderArguments objectAtIndex:CPLogListArgumentList];
    CPLogCommand *command = [[CPLogCommand alloc] init];
    command.logString = [self.blockController.variableManager stringByCombineArrayVariable:arrayArgument.arrayName delimiter:@","];
    [self.blockController sendUiCommand:command];
}

@end
