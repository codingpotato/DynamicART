//
//  CPLine.m
//  DynamicArt
//
//  Created by wangyw on 4/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLine.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPLineCommand.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPLineSocketNext,
    CPLineNumberOfSockets
} CPLineSockets;

typedef enum {
    CPLineArgumentFromX,
    CPLineArgumentFromY,
    CPLineArgumentToX,
    CPLineArgumentToY,
    CPLineNumberOfArguments
} CPLineArguments;

@implementation CPLine

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:200.0],  [CPNumberValue valueWithDouble:200.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPLineNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPLineCommand *command = [[CPLineCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentFromX = [self.syntaxOrderArguments objectAtIndex:CPLineArgumentFromX];
    CPRightValueStrongTypeArgument *argumentFromY = [self.syntaxOrderArguments objectAtIndex:CPLineArgumentFromY];
    CPRightValueStrongTypeArgument *argumentToX = [self.syntaxOrderArguments objectAtIndex:CPLineArgumentToX];
    CPRightValueStrongTypeArgument *argumentToY = [self.syntaxOrderArguments objectAtIndex:CPLineArgumentToY];
    command.from = CGPointMake([argumentFromX calculateResult].doubleValue, [argumentFromY calculateResult].doubleValue);
    command.to = CGPointMake([argumentToX calculateResult].doubleValue, [argumentToY calculateResult].doubleValue);

    [self.blockController sendUiCommand:command];
}

@end
