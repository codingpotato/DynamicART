//
//  CPForward.m
//  DynamicArt
//
//  Created by wangyw on 3/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMoveForward.h"

#import "CPMoveCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPMoveForwardNext,
    CPMoveForwardNumberOfSockets
} CPMoveForwardSockets;

typedef enum {
    CPMoveForwardArgumentStep,
    CPMoveForwardNumberOfArguments
} CPMoveForwardArguments;

@implementation CPMoveForward

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPMoveForwardNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPMoveCommand *command = [[CPMoveCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentStep = [self.syntaxOrderArguments objectAtIndex:CPMoveForwardArgumentStep];
    command.direction = 1;
    command.step = [argumentStep calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
}

@end
