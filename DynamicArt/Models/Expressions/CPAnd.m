//
//  CPAnd.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPAnd.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPBooleanValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPAndArgument1,
    CPAndArgument2,
    CPAndNumberOfArguments
} CPAndArguments;

@implementation CPAnd

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPBooleanValue trueValue], [CPBooleanValue trueValue], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPBooleanValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPAndArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPAndArgument2];
    BOOL result = [argument1 calculateResult].booleanValue && [argument2 calculateResult].booleanValue;
    return [CPBooleanValue valueWithBoolean:result];
}

@end
