//
//  CPPenUp.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPenUp.h"

#import "CPPenCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"

typedef enum {
    CPPenUpSocketNext,
    CPPenUpNumberOfSockets
} CPPenUpSockets;

typedef enum {
    CPPenUpNumberOfArguments
} CPPenUpArguments;

@implementation CPPenUp

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPPenUpNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPPenCommand *command = [[CPPenCommand alloc] init];
    command.penDown = NO;
    [self.blockController sendUiCommand:command];
}

@end
