//
//  CPInsertIntoList.m
//  DynamicArt
//
//  Created by wangyw on 5/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPInsertAtList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPVariableManager.h"

typedef enum {
    CPInsertAtListSocketNext,
    CPInsertAtListNumberOfSockets
} CPInsertAtListSockets;

typedef enum {
    CPInsertAtListArgumentValue,
    CPInsertAtListArgumentIndex,
    CPInsertAtListArgumentList,
    CPInsertAtListNumberOfArguments
} CPInsertAtListArguments;

@implementation CPInsertAtList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueWeakTypeArgument class], [CPRightValueStrongTypeArgument class], [CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], [CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPInsertAtListNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueWeakTypeArgument *argumentvalue = [self.syntaxOrderArguments objectAtIndex:CPInsertAtListArgumentValue];
    CPRightValueStrongTypeArgument *argumentIndex = [self.syntaxOrderArguments objectAtIndex:CPInsertAtListArgumentIndex];
    CPArrayArgument *argumentList = [self.syntaxOrderArguments objectAtIndex:CPInsertAtListArgumentList];
    [self.blockController.variableManager insertValue:[argumentvalue calculateResult] atIndex:[argumentIndex calculateResult].intValue inArrayVariable:argumentList.arrayName];
}

@end
