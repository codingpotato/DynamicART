//
//  CPSetVariable.m
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

#import "CPSetVariable.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPHeadStatement.h"
#import "CPLeftValueArgument.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPVariableManager.h"

typedef enum {
    CPSetVariableSocketNext,
    CPSetVariableNumberOfSockets
} CPSetVariableSockets;

typedef enum {
    CPSetVariableArgumentVariable,
    CPSetVariableArgumentValue,
    CPSetVariableNumberOfArguments
} CPSetVariableArguments;

@implementation CPSetVariable

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPLeftValueArgument class], [CPRightValueWeakTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSetVariableNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPLeftValueArgument *argumentVariable = [self.syntaxOrderArguments objectAtIndex:CPSetVariableArgumentVariable];
    CPRightValueWeakTypeArgument *argumentValue = [self.syntaxOrderArguments objectAtIndex:CPSetVariableArgumentValue];
    [self.blockController.variableManager setValue:[argumentValue calculateResult] forVariable:argumentVariable.variableName];
}

@end
