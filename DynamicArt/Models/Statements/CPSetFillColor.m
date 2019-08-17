//
//  CPSetFillColor.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetFillColor.h"

#import "CPSetColorCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPColorValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPSetFillColorNext,
    CPSetFillColorNumberOfSockets
} CPSetFillColorSockets;

typedef enum {
    CPSetFillColorArgumentColor,
    CPSetFillColorNumberOfArguments
} CPSetFillColorArguments;

@implementation CPSetFillColor

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPColorValue valueWithRed:CPColorValueComponentMax green:CPColorValueComponentMax blue:CPColorValueComponentMax alpha:CPColorValueComponentMax], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSetFillColorNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPSetColorCommand *command = [[CPSetColorCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentColor = [self.syntaxOrderArguments objectAtIndex:CPSetFillColorArgumentColor];
    command.fillColor = [argumentColor calculateResult].uiColor;
    command.lineColor = nil;
    [self.blockController sendUiCommand:command];
}

@end
