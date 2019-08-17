//
//  CPMyStartup.m
//  DynamicArt
//
//  Created by wangyw on 10/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMyStartup.h"

#import "CPMyStartupArgument.h"
#import "CPBlockConfiguration.h"
#import "CPStringValue.h"

typedef enum {
    CPMyStartupSocketNext,
    CPMyStartupNumberOfSockets
} CPMyStartupSockets;

typedef enum {
    CPMyStartupArgumentName,
    CPMyStartupNumberOfArguments
} CPMyStartupArguments;

@implementation CPMyStartup

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPMyStartupArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPStringValue valueWithString:@"My blockette"], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorGreen numberOfSockets:CPMyStartupNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (NSString *)name {
    CPMyStartupArgument *argumentName = [self.syntaxOrderArguments objectAtIndex:CPMyStartupArgumentName];
    NSAssert(argumentName, @"");
    return argumentName.startupName;
}

- (void)execute {
}

@end
