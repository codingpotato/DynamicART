//
//  CPClear.m
//  DynamicArt
//
//  Created by wangyw on 4/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPClear.h"

#import "CPClearCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPColorValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPClearNext,
    CPClearNumberOfSockets
} CPClearSockets;

typedef enum {
    CPClearArgumentColor,
    CPClearNumberOfArguments
} CPClearArguments;

@implementation CPClear

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPColorValue valueWithRed:CPColorValueComponentMax green:CPColorValueComponentMax blue:CPColorValueComponentMax alpha:CPColorValueComponentMax], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPClearNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPClearCommand *command = [[CPClearCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentColor = [self.syntaxOrderArguments objectAtIndex:CPClearArgumentColor];
    command.color = [argumentColor calculateResult].uiColor;
    [self.blockController sendUiCommand:command];
}

@end
