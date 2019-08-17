//
//  CPReplaceListWith.m
//  DynamicArt
//
//  Created by wangyw on 5/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPReplaceListWith.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPVariableManager.h"

typedef enum {
    CPReplaceListWithSocketNext,
    CPReplaceListWithNumberOfSockets
} CPReplaceListWithSockets;

typedef enum {
    CPReplaceListWithArgumentIndex,
    CPReplaceListWithArgumentList,
    CPReplaceListWithArgumentValue,
    CPReplaceListWithNumberOfArguments
} CPReplaceListWithArguments;

@implementation CPReplaceListWith

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPArrayArgument class], [CPRightValueWeakTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNullValue null], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPReplaceListWithNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argumentIndex = [self.syntaxOrderArguments objectAtIndex:CPReplaceListWithArgumentIndex];
    CPArrayArgument *argumentList = [self.syntaxOrderArguments objectAtIndex:CPReplaceListWithArgumentList];
    CPRightValueWeakTypeArgument *argumentValue = [self.syntaxOrderArguments objectAtIndex:CPReplaceListWithArgumentValue];
    [self.blockController.variableManager replaceValue:[argumentValue calculateResult] atIndex:[argumentIndex calculateResult].intValue inArrayVariable:argumentList.arrayName];
}

@end
