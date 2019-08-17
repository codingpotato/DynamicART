//
//  CPCast.m
//  DynamicArt
//
//  Created by wangyw on 11/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCast.h"

#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPColorValue.h"
#import "CPNumberValue.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPStringValue.h"
#import "CPVariableTypeArgument.h"

typedef enum {
    CPCastArgumentValue,
    CPCastArgumentType,
    CPCastNumberOfArguments
} CPCastArguments;

@implementation CPCast

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueWeakTypeArgument class], [CPVariableTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:nil syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueWeakTypeArgument *argumentValue = [self.syntaxOrderArguments objectAtIndex:CPCastArgumentValue];
    CPVariableTypeArgument *argumentType = [self.syntaxOrderArguments objectAtIndex:CPCastArgumentType];
    switch (argumentType.index) {
        case CPVariableTypeBoolean:
            if ([argumentValue.value isKindOfClass:[CPBooleanValue class]]) {
                return argumentValue.value;
            } else {
                return [CPBooleanValue valueWithBoolean:argumentValue.value.booleanValue];
            }
        case CPVariableTypeColor:
            if ([argumentValue.value isKindOfClass:[CPColorValue class]]) {
                return argumentValue.value;
            } else {
                return [CPColorValue valueWithUIColor:argumentValue.value.uiColor];
            }
        case CPVariableTypeNumber:
            if ([argumentValue.value isKindOfClass:[CPNumberValue class]]) {
                return argumentValue.value;
            } else {
                return [CPNumberValue valueWithDouble:argumentValue.value.doubleValue];
            }
        case CPVariableTypeString:
            if ([argumentValue.value isKindOfClass:[CPStringValue class]]) {
                return argumentValue.value;
            } else {
                return [CPStringValue valueWithString:argumentValue.value.stringValue];
            }
        default:
            NSAssert(NO, @"");
            return nil;
    }
}

@end
