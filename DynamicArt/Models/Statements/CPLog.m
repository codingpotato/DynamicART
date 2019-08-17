//
//  CPLog.m
//  DynamicArt
//
//  Created by wangyw on 4/15/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLog.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPLogCommand.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPStringValue.h"

typedef enum {
    CPLogNext,
    CPLogNumberOfSockets
} CPLogSockets;

typedef enum {
    CPLogArgumentText,
    CPLogNumberOfArguments
} CPLogArguments;

@implementation CPLog

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueWeakTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPStringValue valueWithString:@"Hello World"], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPLogNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPLogCommand *command = [[CPLogCommand alloc] init];
    CPRightValueWeakTypeArgument *argumentText = [self.syntaxOrderArguments objectAtIndex:CPLogArgumentText];
    command.logString = [argumentText calculateResult].stringValue;
    [self.blockController sendUiCommand:command];
}

@end
