//
//  CPAdd.m
//  DynamicArt
//
//  Created by wangyw on 3/8/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPAdd.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPAddArgument1,
    CPAddArgument2,
    CPAddNumberOfArguments
} CPAddArguments;

@implementation CPAdd

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPAddArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPAddArgument2];
    double result = [argument1 calculateResult].doubleValue + [argument2 calculateResult].doubleValue;
    return [CPNumberValue valueWithDouble:result];
}

@end
