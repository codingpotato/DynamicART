//
//  CPJoin.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPJoin.h"

#import "CPBlockConfiguration.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPStringValue.h"

typedef enum {
    CPJoinArgument1,
    CPJoinArgument2,
    CPJoinNumberOfArguments
} CPJoinArguments;

@implementation CPJoin

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPStringValue valueWithString:@"Hello World"], [CPStringValue valueWithString:@", man"], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPStringValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPJoinArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPJoinArgument2];
    NSString *result = [[argument1 calculateResult].stringValue stringByAppendingString:[argument2 calculateResult].stringValue];
    return [CPStringValue valueWithString:result];
}

@end
