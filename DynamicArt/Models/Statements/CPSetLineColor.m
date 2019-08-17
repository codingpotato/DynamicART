//
//  CPSetLineColor.m
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetLineColor.h"

#import "CPSetColorCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPColorValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPSetLineColorNext,
    CPSetLineColorNumberOfSockets
} CPSetLineColorSockets;

typedef enum {
    CPSetLineColorArgumentColor,
    CPSetLineColorNumberOfArguments
} CPSetLineColorArguments;

@implementation CPSetLineColor

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPColorValue valueWithRed:CPColorValueComponentMax green:CPColorValueComponentMax blue:CPColorValueComponentMax alpha:CPColorValueComponentMax], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSetLineColorNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPSetColorCommand *command = [[CPSetColorCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentColor = [self.syntaxOrderArguments objectAtIndex:CPSetLineColorArgumentColor];
    command.lineColor = [argumentColor calculateResult].uiColor;
    command.fillColor = nil;
    [self.blockController sendUiCommand:command];
}

@end
