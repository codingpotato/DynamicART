//
//  CPWhenTouchBegin.m
//  DynamicArt
//
//  Created by wangyw on 3/28/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWhenTouchBegin.h"

#import "CPBlockConfiguration.h"
#import "CPVariableManager.h"

typedef enum {
    CPWhenTouchBeginSocketNext,
    CPWhenTouchBeginNumberOfSockets
} CPWhenTouchBeginSockets;

typedef enum {
    CPWhenTouchBeginNumberOfArguments
} CPWhenTouchBeginArguments;

@implementation CPWhenTouchBegin

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorGreen numberOfSockets:CPWhenTouchBeginNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

@end
