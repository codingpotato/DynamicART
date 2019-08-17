//
//  CPHeading.m
//  DynamicArt
//
//  Created by wangyw on 11/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPHeading.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPHeadingCommand.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPHeadingNext,
    CPHeadingNumberOfSockets
} CPToSockets;

typedef enum {
    CPHeadingArgumentX,
    CPHeadingArgumentY,
    CPHeadingNumberOfArguments
} CPHeadingArguments;

@implementation CPHeading

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPHeadingNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPHeadingCommand *command = [[CPHeadingCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPHeadingArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPHeadingArgumentY];
    command.target = CGPointMake([argumentX calculateResult].doubleValue, [argumentY calculateResult].doubleValue);
    [self.blockController sendUiCommand:command];
}

@end
