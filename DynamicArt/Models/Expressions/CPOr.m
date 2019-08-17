//
//  CPOr.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPOr.h"

#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPOrArgument1,
    CPOrArgument2,
    CPOrNumberOfArguments
} CPOrArguments;

@implementation CPOr

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPBooleanValue trueValue], [CPBooleanValue trueValue], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPBooleanValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPOrArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPOrArgument2];
    double result = [argument1 calculateResult].booleanValue | [argument2 calculateResult].booleanValue;
    return [CPBooleanValue valueWithBoolean:result];
}

@end
