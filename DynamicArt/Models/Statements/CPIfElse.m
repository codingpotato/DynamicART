//
//  CPIfElse.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPIfElse.h"

#import "CPBLockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPIfElseSocketIf,
    CPIfElseSocketElse,
    CPIfElseSocketNext,
    CPIfElseNumberOfSockets
} CPIfElseSockets;

typedef enum {
    CPIfElseArgument,
    CPIfElseNumberOfArguments
} CPIfElseArguments;

@implementation CPIfElse

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPBooleanValue trueValue], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorOrange numberOfSockets:CPIfElseNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPIfElseArgument];
    if ([argument calculateResult].booleanValue) {
        [self executeAllNextStatementsAtIndex:CPIfElseSocketIf];
    } else {
        [self executeAllNextStatementsAtIndex:CPIfElseSocketElse];
    }
}

@end
