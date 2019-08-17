//
//  CPBeatsPerMinute.m
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBeatsPerMinute.h"

#import "CPBeatsPerMinuteCommand.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPNumberValue.h"

typedef enum {
    CPBeatsPerMinuteSocketNext,
    CPBeatsPerMinuteNumberOfSockets
} CPBeatsPerMinuteSockets;

typedef enum {
    CPBeatsPerMinuteArgument,
    CPBeatsPerMinuteNumberOfArguments
} CPBeatsPerMinuteArguments;

@implementation CPBeatsPerMinute

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:120.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPBeatsPerMinuteNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueWeakTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPBeatsPerMinuteArgument];
    CPBeatsPerMinuteCommand *command = [[CPBeatsPerMinuteCommand alloc] init];
    command.beatsPerMinute = [argument calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
}

@end
