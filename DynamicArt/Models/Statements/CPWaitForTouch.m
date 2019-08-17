//
//  CPWaitForTouch.m
//  DynamicArt
//
//  Created by wangyw on 4/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWaitForTouch.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPConditions.h"

typedef enum {
    CPWaitForTouchSocketNext,
    CPWaitForTouchNumberOfSockets
} CPWaitForTouchSockets;

typedef enum {
    CPWaitForTouchNumberOfArguments
} CPWaitForTouchArguments;

@implementation CPWaitForTouch

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPWaitForTouchNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    [self.blockController.conditions waitForTouch];
}

@end
