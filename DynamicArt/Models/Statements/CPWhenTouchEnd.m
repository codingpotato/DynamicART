//
//  CPWhenTouchEnd.m
//  DynamicArt
//
//  Created by wangyw on 4/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWhenTouchEnd.h"

#import "CPBlockConfiguration.h"
#import "CPVariableManager.h"

typedef enum {
    CPWhenTouchEndSocketNext,
    CPWhenTouchEndNumberOfSockets
} CPWhenTouchEndSockets;

typedef enum {
    CPWhenTouchEndNumberOfArguments
} CPWhenTouchEndArguments;

@implementation CPWhenTouchEnd

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorGreen numberOfSockets:CPWhenTouchEndNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

@end
