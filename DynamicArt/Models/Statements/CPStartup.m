//
//  CPStartup.m
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

#import "CPStartup.h"

#import "CPBlockConfiguration.h"

typedef enum {
    CPStartupSocketNext,
    CPStartupNumberOfSockets
} CPStartupSockets;

typedef enum {
    CPStartupNumberOfArguments
} CPStartupArguments;

@implementation CPStartup

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorGreen numberOfSockets:CPStartupNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
}

@end
