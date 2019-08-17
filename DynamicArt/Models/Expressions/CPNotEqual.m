//
//  CPNotEqual.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPNotEqual.h"

#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPColorValue.h"
#import "CPNumberValue.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPStringValue.h"

typedef enum {
    CPNotEqualArgument1,
    CPNotEqualArgument2,
    CPNotEqualNumberOfArguments
} CPNotEqualArguments;

@implementation CPNotEqual

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueWeakTypeArgument class], [CPRightValueWeakTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPBooleanValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueWeakTypeArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPNotEqualArgument1];
    CPRightValueWeakTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPNotEqualArgument2];
    id<CPValue> result1 = [argument1 calculateResult];
    id<CPValue> result2 = [argument2 calculateResult];
    if ([result1 isKindOfClass:[CPNumberValue class]]) {
        double diff = result1.doubleValue - result2.doubleValue;
        if (diff < 0) {
            diff = -diff;
        }
        return [CPBooleanValue valueWithBoolean:diff >= [CPNumberValue zeroTolerance]];
    } else if ([result1 isKindOfClass:[CPBooleanValue class]]) {
        return [CPBooleanValue valueWithBoolean:result1.booleanValue != result2.booleanValue];
    } else if ([result1 isKindOfClass:[CPColorValue class]]) {
        return [CPBooleanValue valueWithBoolean:![result1.uiColor isEqual:result2.uiColor]];
    } else if ([result1 isKindOfClass:[CPStringValue class]]) {
        return [CPBooleanValue valueWithBoolean:![result1.stringValue isEqualToString:result2.stringValue]];
    } else {
        NSAssert(NO, @"");
        return nil;
    }
}

@end
