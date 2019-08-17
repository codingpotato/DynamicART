//
//  CPGoHome.m
//  DynamicArt
//
//  Created by wangyw on 4/27/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPGoHome.h"

#import "CPGoHomeCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"

typedef enum {
    CPGoHomeNext,
    CPGoHomeNumberOfSockets
} CPToSockets;

typedef enum {
    CPGoHomeNumberOfArguments
} CPGoHomeArguments;

@implementation CPGoHome

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPGoHomeNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPGoHomeCommand *command = [[CPGoHomeCommand alloc] init];
    [self.blockController sendUiCommand:command];
}

@end
