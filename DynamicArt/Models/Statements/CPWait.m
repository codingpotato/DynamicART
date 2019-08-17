//
//  CPWait.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWait.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPConditions.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPWaitCommand.h"

typedef enum {
    CPWaitSocketNext,
    CPWaitNumberOfSockets
} CPWaitSockets;

typedef enum {
    CPWaitArgumentSeconds,
    CPWaitNumberOfArguments
} CPWaitArguments;

@implementation CPWait

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.5], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPWaitNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPWaitArgumentSeconds];
    CPWaitCommand *command = [[CPWaitCommand alloc] init];
    command.condition = [self.blockController.conditions allocateCondition];
    command.interval = [argument calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
    
    [self.blockController.conditions waitForCondition:command.condition];
}

@end
