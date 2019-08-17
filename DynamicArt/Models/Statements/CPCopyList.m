//
//  CPCopyList.m
//  DynamicArt
//
//  Created by wangyw on 11/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCopyList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPCopyListSocketNext,
    CPCopyListNumberOfSockets
} CPCopyListSockets;

typedef enum {
    CPCopyListArgumentList1,
    CPCopyListArgumentList2,
    CPCopyListNumberOfArguments
} CPCopyListArguments;

@implementation CPCopyList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPArrayArgument class], [CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], [CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPCopyListNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPArrayArgument *argumentList1 = [self.syntaxOrderArguments objectAtIndex:CPCopyListArgumentList1];
    CPArrayArgument *argumentList2 = [self.syntaxOrderArguments objectAtIndex:CPCopyListArgumentList2];
    [self.blockController.variableManager copyArrayFromVariable:argumentList1.arrayName toVariable:argumentList2.arrayName];
}

@end
