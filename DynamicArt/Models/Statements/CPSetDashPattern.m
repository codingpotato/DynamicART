//
//  CPSetDashPattern.m
//  DynamicArt
//
//  Created by wangyw on 11/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetDashPattern.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPSetDashPatternCommand.h"

typedef enum {
    CPSetDashPatternNext,
    CPSetDashPatternNumberOfSockets
} CPSetDashPatternSockets;

typedef enum {
    CPSetDashPatternArgumentPaintLength,
    CPSetDashPatternArgumentUnpaintLength,
    CPSetDashPatternNumberOfArguments
} CPSetDashPatternArguments;

@implementation CPSetDashPattern

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:2.0], [CPNumberValue valueWithDouble:1.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSetDashPatternNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPSetDashPatternCommand *command = [[CPSetDashPatternCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentPaintLength = [self.syntaxOrderArguments objectAtIndex:CPSetDashPatternArgumentPaintLength];
    CPRightValueStrongTypeArgument *argumentUnpaintLength = [self.syntaxOrderArguments objectAtIndex:CPSetDashPatternArgumentUnpaintLength];
    command.paintLength = [argumentPaintLength calculateResult].doubleValue;
    command.unpaintLength = [argumentUnpaintLength calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
}

@end
