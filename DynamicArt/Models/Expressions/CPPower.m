//
//  CPPower.m
//  DynamicArt
//
//  Created by wangyw on 12/5/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPower.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPPowerArgument1,
    CPPowerArgument2,
    CPPowerNumberOfArguments
} CPPowerArguments;

@implementation CPPower

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:2.0], [CPNumberValue valueWithDouble:2.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPPowerArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPPowerArgument2];
    double result = pow([argument1 calculateResult].doubleValue, [argument2 calculateResult].doubleValue);
    return [CPNumberValue valueWithDouble:result];
}

@end
