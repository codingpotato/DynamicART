//
//  CPNot.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPNot.h"

#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPNotArgument,
    CPNotNumberOfArguments
} CPNotArguments;

@implementation CPNot

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPBooleanValue falseValue], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPBooleanValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPNotArgument];
    BOOL result = ![argument calculateResult].booleanValue;
    return [CPBooleanValue valueWithBoolean:result];
}

@end
