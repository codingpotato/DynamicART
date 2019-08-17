//
//  CPGreat.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPGreat.h"

#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPNumberValue.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPStringValue.h"

typedef enum {
    CPGreatArgument1,
    CPGreatArgument2,
    CPGreatNumberOfArguments
} CPGreatArguments;

@implementation CPGreat

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueWeakTypeArgument class], [CPRightValueWeakTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPBooleanValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueWeakTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPGreatArgument1];
    CPRightValueWeakTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPGreatArgument2];
    id<CPValue> result1 = [argument1 calculateResult];
    id<CPValue> result2 = [argument2 calculateResult];
    if ([result1 isKindOfClass:[CPStringValue class]]) {
        return [CPBooleanValue valueWithBoolean:[result1.stringValue compare:result2.stringValue] == NSOrderedDescending];
    } else {
        return [CPBooleanValue valueWithBoolean:result1.doubleValue > result2.doubleValue];
    }
}

@end
