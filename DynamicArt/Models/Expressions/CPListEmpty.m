//
//  CPListEmpty.m
//  DynamicArt
//
//  Created by wangyw on 11/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPListEmpty.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPBooleanValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPListEmptyArgumentArray,
} CPListEmptyArguments;

@implementation CPListEmpty

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPBooleanValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPArrayArgument *argumentArray = [self.syntaxOrderArguments objectAtIndex:CPListEmptyArgumentArray];
    return [CPBooleanValue valueWithBoolean:[self.blockController.variableManager countOfArrayVariable:argumentArray.arrayName] == 0];
}

@end
