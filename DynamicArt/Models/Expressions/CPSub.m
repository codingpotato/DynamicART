//
//  CPSub.m
//  DynamicArt
//
//  Created by wangyw on 3/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSub.h"

#import "CPBlockConfiguration.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPSubArgument1,
    CPSubArgument2,
    CPSubNumberOfArguments
} CPSubArguments;

@implementation CPSub

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPSubArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPSubArgument2];
    double result = [argument1 calculateResult].doubleValue - [argument2 calculateResult].doubleValue;
    return [CPNumberValue valueWithDouble:result];
}

@end
