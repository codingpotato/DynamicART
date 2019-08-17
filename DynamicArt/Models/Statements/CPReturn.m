//
//  CPReturn.m
//  DynamicArt
//
//  Created by wangyw on 10/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPReturn.h"

#import "CPBlockConfiguration.h"
#import "CPException.h"

typedef enum {
    CPReturnNumberOfSockets
} CPReturnSockets;

typedef enum {
    CPReturnNumberOfArguments
} CPReturnArguments;

@implementation CPReturn

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPReturnNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    @throw [[CPReturnException alloc] initWithName:@"Return" reason:nil userInfo:nil];
}

@end
