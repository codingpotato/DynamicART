//
//  CPPlaySound.m
//  DynamicArt
//
//  Created by wangyw on 11/26/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPlaySound.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPConditions.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPPlaySoundCommand.h"

typedef enum {
    CPPlaySoundSocketNext,
    CPPlaySoundNumberOfSockets
} CPPlaySoundSockets;

typedef enum {
    CPPlaySoundArgumentFrequency,
    CPPlaySoundArgumentInterval,
    CPPlaySoundNumberOfArguments
} CPPlaySoundArguments;

@implementation CPPlaySound

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:440.0], [CPNumberValue valueWithDouble:1.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPPlaySoundNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argumentFrequency = [self.syntaxOrderArguments objectAtIndex:CPPlaySoundArgumentFrequency];
    CPRightValueStrongTypeArgument *argumentInterval = [self.syntaxOrderArguments objectAtIndex:CPPlaySoundArgumentInterval];
    CPPlaySoundCommand *command = [[CPPlaySoundCommand alloc] init];
    command.frequency = [argumentFrequency calculateResult].doubleValue;
    command.interval = [argumentInterval calculateResult].doubleValue;
    command.condition = [self.blockController.conditions allocateCondition];
    [self.blockController sendUiCommand:command];
    
    [self.blockController.conditions waitForCondition:command.condition];
}

@end
