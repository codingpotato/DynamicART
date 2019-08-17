//
//  CPRandomNumber.m
//  DynamicArt
//
//  Created by wangyw on 3/31/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRandom.h"

#import "CPBlockConfiguration.h"
#import "CPNumberValue.h"
#import "CPBlockController.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPRandomArgumentFrom,
    CPRandomArgumentTo,
    CPRandomNumberOfArguments
} CPRandomArguments;

@implementation CPRandom

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:100.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argumentFrom = [self.syntaxOrderArguments objectAtIndex:CPRandomArgumentFrom];
    CPRightValueStrongTypeArgument *argumentTo = [self.syntaxOrderArguments objectAtIndex:CPRandomArgumentTo];
    
    NSInteger from = [argumentFrom calculateResult].intValue;
    NSInteger to = [argumentTo calculateResult].intValue;
    return [CPNumberValue valueWithDouble:(NSInteger)(arc4random() % (to - from + 1)) + from];
}

@end
