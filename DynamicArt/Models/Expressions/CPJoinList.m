//
//  CPJoinList.m
//  DynamicArt
//
//  Created by wangyw on 11/17/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPJoinList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPStringValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPJoinListArgumentList,
    CPJoinListArgumentDelimiter,
    CPJoinListNumberOfArguments
} CPJoinListArguments;

@implementation CPJoinList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPArrayArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], [CPStringValue valueWithString:@","], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPStringValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPArrayArgument *argumentlist = [self.syntaxOrderArguments objectAtIndex:CPJoinListArgumentList];
    CPRightValueStrongTypeArgument *argumentDelimiter = [self.syntaxOrderArguments objectAtIndex:CPJoinListArgumentDelimiter];
    NSString *result = [self.blockController.variableManager stringByCombineArrayVariable:argumentlist.arrayName delimiter:[argumentDelimiter calculateResult].stringValue];
    return [CPStringValue valueWithString:result];
}

@end
