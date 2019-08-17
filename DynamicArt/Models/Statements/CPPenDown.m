//
//  CPPenDown.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPenDown.h"

#import "CPPenCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"

typedef enum {
    CPPenDownSocketNext,
    CPPenDownNumberOfSockets
} CPPenDownSockets;

typedef enum {
    CPPenDownNumberOfArguments
} CPPenDownArguments;

@implementation CPPenDown

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPPenDownNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPPenCommand *command = [[CPPenCommand alloc] init];
    command.penDown = YES;
    [self.blockController sendUiCommand:command];
}

@end
