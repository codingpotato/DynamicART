//
//  CPAddToList.m
//  DynamicArt
//
//  Created by wangyw on 5/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPAddToList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPVariableManager.h"

typedef enum {
    CPAddToListSocketNext,
    CPAddToListNumberOfSockets
} CPAddToListSockets;

typedef enum {
    CPAddToListArgumentValue,
    CPAddToListArgumentList,
    CPAddToListNumberOfArguments
} CPAddToListArguments;

@implementation CPAddToList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueWeakTypeArgument class], [CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPAddToListNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueWeakTypeArgument *argumentValue = [self.syntaxOrderArguments objectAtIndex:CPAddToListArgumentValue];
    CPArrayArgument *argumentList = [self.syntaxOrderArguments objectAtIndex:CPAddToListArgumentList];
    [self.blockController.variableManager addValue:[argumentValue calculateResult] inArrayVariable:argumentList.arrayName];
}

@end
