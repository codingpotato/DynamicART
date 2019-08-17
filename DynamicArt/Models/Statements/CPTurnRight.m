//
//  CPTurnRight.m
//  DynamicArt
//
//  Created by wangyw on 3/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTurnRight.h"

#import "CPTurnCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPTuenRightNext,
    CPTuenRightNumberOfSockets
} CPTuenRightSockets;

typedef enum {
    CPTuenRightArgumentAngle,
    CPTuenRightNumberOfArguments
} CPTuenRightArguments;

@implementation CPTurnRight

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:90.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPTuenRightNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPTurnCommand *command = [[CPTurnCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentAngle = [self.syntaxOrderArguments objectAtIndex:CPTuenRightArgumentAngle];
    command.direction = 1;
    command.angle = [argumentAngle calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
}

@end
