//
//  CPIf.m
//  DynamicArt
//
//  Created by wangyw on 3/28/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPIf.h"

#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPIfSocketInner,
    CPIfSocketNext,
    CPIfNumberOfSockets
} CPIfSockets;

typedef enum {
    CPIfArgument,
    CPIfNumberOfArguments
} CPIfArguments;

@implementation CPIf

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPBooleanValue trueValue], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorOrange numberOfSockets:CPIfNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPIfArgument];
    
    if ([argument calculateResult].booleanValue) {
        [self executeAllNextStatementsAtIndex:CPIfSocketInner];
    }
}

@end
