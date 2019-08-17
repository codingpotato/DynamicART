//
//  CPSetFont.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetFont.h"

#import "CPSetFontCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPFontArgument.h"
#import "CPNumberValue.h"

typedef enum {
    CPSetFontNext,
    CPSetFontNumberOfSockets
} CPSetFontSockets;

typedef enum {
    CPSetFontArgument,
    CPSetFontNumberOfArguments
} CPSetFontArguments;

@implementation CPSetFont

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPFontArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSetFontNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPSetFontCommand *command = [[CPSetFontCommand alloc] init];
    CPFontArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPSetFontArgument];
    command.name = [argument.listArray objectAtIndex:argument.index];
    [self.blockController sendUiCommand:command];
}

@end
