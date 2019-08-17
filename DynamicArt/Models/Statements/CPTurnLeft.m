//
//  CPTurnLeft.m
//  DynamicArt
//
//  Created by wangyw on 3/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTurnLeft.h"

#import "CPTurnCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPTurnLeftNext,
    CPTurnLeftNumberOfSockets
} CPTurnLeftSockets;

typedef enum {
    CPTurnLeftArgumentAngle,
    CPTurnLeftNumberOfArguments
} CPTurnLeftArguments;

@implementation CPTurnLeft

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:90.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPTurnLeftNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPTurnCommand *command = [[CPTurnCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentAngle = [self.syntaxOrderArguments objectAtIndex:CPTurnLeftArgumentAngle];
    command.direction = -1;
    command.angle = [argumentAngle calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
}

@end
