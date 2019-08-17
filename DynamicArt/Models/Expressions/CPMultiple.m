//
//  CPMultiple.m
//  DynamicArt
//
//  Created by wangyw on 3/28/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMultiple.h"

#import "CPBlockConfiguration.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPMultipleArgument1,
    CPMultipleArgument2,
    CPMultipleNumberOfArguments
} CPMultipleArguments;

@implementation CPMultiple

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPMultipleArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPMultipleArgument2];
    double result = [argument1 calculateResult].doubleValue * [argument2 calculateResult].doubleValue;
    return [CPNumberValue valueWithDouble:result];
}

@end
