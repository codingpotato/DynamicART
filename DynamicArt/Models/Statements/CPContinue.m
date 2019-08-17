//
//  CPContinue.m
//  DynamicArt
//
//  Created by wangyw on 4/8/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPContinue.h"

#import "CPBlockConfiguration.h"
#import "CPException.h"

typedef enum {
    CPContinueNumberOfSockets
} CPContinueSockets;

typedef enum {
    CPContinueNumberOfArguments
} CPContinueArguments;

@implementation CPContinue

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPContinueNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    @throw [[CPContinueException alloc] initWithName:@"Continue" reason:nil userInfo:nil];
}

@end
