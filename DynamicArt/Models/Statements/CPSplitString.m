//
//  CPSplitString.m
//  DynamicArt
//
//  Created by wangyw on 11/17/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSplitString.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNullValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPStringValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPSplitStringSocketNext,
    CPSplitStringNumberOfSockets
} CPSplitStringSockets;

typedef enum {
    CPSplitStringArgumentString,
    CPSplitStringArgumentList,
    CPSplitStringArgumentDelimiter,
    CPSplitStringNumberOfArguments
} CPSplitStringArguments;

@implementation CPSplitString

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPArrayArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPStringValue valueWithString:@"HelloWorld,man"], [CPNullValue null], [CPStringValue valueWithString:@","], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSplitStringNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argumentString = [self.syntaxOrderArguments objectAtIndex:CPSplitStringArgumentString];
    CPArrayArgument *argumentList = [self.syntaxOrderArguments objectAtIndex:CPSplitStringArgumentList];
    CPRightValueStrongTypeArgument *argumentDelimiter = [self.syntaxOrderArguments objectAtIndex:CPSplitStringArgumentDelimiter];
    [self.blockController.variableManager splitString:[argumentString calculateResult].stringValue toArrayVariable:argumentList.arrayName delimiter:[argumentDelimiter calculateResult].stringValue];
}

@end
