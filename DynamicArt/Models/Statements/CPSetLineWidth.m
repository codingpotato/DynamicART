//
//  CPSetLineWidth.m
//  DynamicArt
//
//  Created by wangyw on 3/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetLineWidth.h"

#import "CPSetLineWidthCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPSetLineWidthNext,
    CPSetLineWidthNumberOfSockets
} CPSetLineWidthSockets;

typedef enum {
    CPSetLineWidthArgument,
    CPSetLineWidthNumberOfArguments
} CPSetLineWidthArguments;

@implementation CPSetLineWidth

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:1.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSetLineWidthNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPSetLineWidthCommand *command = [[CPSetLineWidthCommand alloc] init];
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPSetLineWidthArgument];
    command.lineWidth = [argument calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
}

@end
