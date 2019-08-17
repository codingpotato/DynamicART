//
//  CPClearList.m
//  DynamicArt
//
//  Created by wangyw on 11/12/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPClearList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPClearListSocketNext,
    CPClearListNumberOfSockets
} CPClearListSockets;

typedef enum {
    CPClearListArgumentList,
    CPClearListNumberOfArguments
} CPClearListArguments;

@implementation CPClearList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPClearListNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPArrayArgument *argumentList = [self.syntaxOrderArguments objectAtIndex:CPClearListArgumentList];
    [self.blockController.variableManager clearArrayVariable:argumentList.arrayName];
}

@end
