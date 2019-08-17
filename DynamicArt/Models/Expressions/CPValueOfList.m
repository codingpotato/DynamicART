//
//  CPValueOfList.m
//  DynamicArt
//
//  Created by wangyw on 5/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPValueOfList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPVariableManager.h"

typedef enum {
    CPValueOfListArgumentIndex,
    CPValueOfListArgumentArray,
} CPValueOfListArguments;

@implementation CPValueOfList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:nil syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argumentIndex = [self.syntaxOrderArguments objectAtIndex:CPValueOfListArgumentIndex];
    CPArrayArgument *argumentArray = [self.syntaxOrderArguments objectAtIndex:CPValueOfListArgumentArray];
    return [self.blockController.variableManager valueAtIndex:[argumentIndex calculateResult].intValue ofArrayVariable:argumentArray.arrayName];
}

@end
