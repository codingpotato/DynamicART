//
//  CPBreak.m
//  DynamicArt
//
//  Created by wangyw on 4/8/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBreak.h"

#import "CPBlockConfiguration.h"
#import "CPException.h"

typedef enum {
    CPBreakNumberOfSockets
} CPBreakSockets;

typedef enum {
    CPBreakNumberOfArguments
} CPBreakArguments;

@implementation CPBreak

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPBreakNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    @throw [[CPBreakException alloc] initWithName:@"Break" reason:nil userInfo:nil];
}

@end
