//
//  CPRemoveLastItemOfList.m
//  DynamicArt
//
//  Created by wangyw on 5/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRemoveLastItemOfList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPRemoveLastItemOfListSocketNext,
    CPRemoveLastItemOfListNumberOfSockets
} CPRemoveLastItemOfListSockets;

typedef enum {
    CPRemoveLastItemOfListArgumentList,
    CPRemoveLastItemOfListNumberOfArguments
} CPRemoveLastItemOfListArguments;

@implementation CPRemoveLastItemOfList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPRemoveLastItemOfListNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPArrayArgument *argumentList = [self.syntaxOrderArguments objectAtIndex:CPRemoveLastItemOfListArgumentList];
    [self.blockController.variableManager removeLastItemInArrayVariable:argumentList.arrayName];
}

@end
