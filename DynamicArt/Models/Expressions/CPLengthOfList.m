//
//  CPLengthOfList.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLengthOfList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPLengthOfListArgumentArray,
} CPLengthOfListArguments;

@implementation CPLengthOfList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPArrayArgument *argumentArray = [self.syntaxOrderArguments objectAtIndex:CPLengthOfListArgumentArray];
    return [CPNumberValue valueWithDouble:[self.blockController.variableManager countOfArrayVariable:argumentArray.arrayName]];
}

@end
