//
//  CPMoveTo.m
//  DynamicArt
//
//  Created by wangyw on 3/28/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMoveTo.h"

#import "CPMoveToCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPMoveToNext,
    CPMoveToNumberOfSockets
} CPToSockets;

typedef enum {
    CPMoveToArgumentX,
    CPMoveToArgumentY,
    CPMoveToNumberOfArguments
} CPMoveToArguments;

@implementation CPMoveTo

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPMoveToNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPMoveToCommand *command = [[CPMoveToCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPMoveToArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPMoveToArgumentY];
    command.target = CGPointMake([argumentX calculateResult].doubleValue, [argumentY calculateResult].doubleValue);
    [self.blockController sendUiCommand:command];
}

@end
