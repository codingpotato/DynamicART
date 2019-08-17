//
//  CPRightValueStrongTypeArgument.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRightValueStrongTypeArgument.h"

#import "CPBlock.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPExpression.h"
#import "CPValue.h"

@implementation CPRightValueStrongTypeArgument

- (Class)valueClass {
    id<CPValue> defaultValue = [self.blockConfiguration.defaultValueOfArguments objectAtIndex:self.syntaxOrderIndex];
    return defaultValue.class;
}

- (void)updateValue:(id<CPValue>)value {
    NSAssert([value isKindOfClass:self.valueClass], @"");
    [super updateValue:value];
}

- (BOOL)canConnectToExpression:(CPExpression *)expression {
    if (expression.configuration.resultClass) {
        return self.valueClass == expression.configuration.resultClass;
    } else {
        return YES;
    }
}

@end
