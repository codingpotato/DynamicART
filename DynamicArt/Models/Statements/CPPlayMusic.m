//
//  CPPlayMusic.m
//  DynamicArt
//
//  Created by wangyw on 12/1/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPlayMusic.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPConditions.h"
#import "CPPlayMusicCommand.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPStringValue.h"

typedef enum {
    CPPlayMusicSocketNext,
    CPPlayMusicNumberOfSockets
} CPPlayMusicSockets;

typedef enum {
    CPPlayMusicArgument,
    CPPlayMusicNumberOfArguments
} CPPlayMusicArguments;

@implementation CPPlayMusic

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPStringValue valueWithString:@"C4,D4,E4,F4,G4,A4,B4,+C4"], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPPlayMusicNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPPlayMusicArgument];
    CPPlayMusicCommand *command = [[CPPlayMusicCommand alloc] init];
    command.musicString = [argument calculateResult].stringValue;
    command.condition = [self.blockController.conditions allocateCondition];
    [self.blockController sendUiCommand:command];
    
    [self.blockController.conditions waitForCondition:command.condition];
}

@end
