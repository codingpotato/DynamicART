//
//  CPRemoveFromList.m
//  DynamicArt
//
//  Created by wangyw on 5/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRemoveFromList.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPVariableManager.h"

typedef enum {
    CPRemoveFromListSocketNext,
    CPRemoveFromListNumberOfSockets
} CPRemoveFromListSockets;

typedef enum {
    CPRemoveFromListArgumentIndex,
    CPRemoveFromListArgumentList,
    CPRemoveFromListNumberOfArguments
} CPRemoveFromListArguments;

@implementation CPRemoveFromList

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPRemoveFromListNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argumentIndex = [self.syntaxOrderArguments objectAtIndex:CPRemoveFromListArgumentIndex];
    CPArrayArgument *argumentlist = [self.syntaxOrderArguments objectAtIndex:CPRemoveFromListArgumentList];
    [self.blockController.variableManager removeValueAtIndex:[argumentIndex calculateResult].intValue inArrayVariable:argumentlist.arrayName];
}

@end
