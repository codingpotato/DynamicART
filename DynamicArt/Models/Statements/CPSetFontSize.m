//
//  CPSetFontSize.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetFontSize.h"

#import "CPSetFontSizeCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPSetFontSizeNext,
    CPSetFontSizeNumberOfSockets
} CPSetFontSizeSockets;

typedef enum {
    CPSetFontSizeArgument,
    CPSetFontSizeNumberOfArguments
} CPSetFontSizeArguments;

@implementation CPSetFontSize

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:20.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSetFontSizeNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPSetFontSizeCommand *command = [[CPSetFontSizeCommand alloc] init];
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPSetFontSizeArgument];
    command.size = [argument calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
}

@end
