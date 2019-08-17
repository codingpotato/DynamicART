//
//  CPMod.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMod.h"

#import "CPBlockConfiguration.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPModArgument1,
    CPModArgument2,
    CPModNumberOfArguments
} CPModArguments;

@implementation CPMod

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:1.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPModArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPModArgument2];
    int result = [argument1 calculateResult].intValue % [argument2 calculateResult].intValue;
    return [CPNumberValue valueWithDouble:result];
}

@end
