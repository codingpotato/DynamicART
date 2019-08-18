//
//  CPPerform.m
//  DynamicArt
//
//  Created by wangyw on 10/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#include <stdatomic.h>

#import "CPPerform.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPException.h"
#import "CPMyStartupManager.h"
#import "CPPerformArgument.h"
#import "CPStringValue.h"

typedef enum {
    CPPerformSocketNext,
    CPPerformNumberOfSockets
} CPPerformSockets;

typedef enum {
    CPPerformArgumentName,
    CPPerformNumberOfArguments
} CPPerformArguments;

@implementation CPPerform

static atomic_int _recursionDepth = 0;

+ (void)resetRecursionDepth {
    _recursionDepth = 0;
}

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPPerformArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPStringValue valueWithString:@"My startup"], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPPerformNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    if (atomic_fetch_add(&_recursionDepth, 1) > 500) {
        @throw [[CPReturnException alloc] initWithName:@"Return" reason:nil userInfo:nil];
    }
    
    if (!self.blockController.isForceQuit) {
        // need check isForceQuit to quit and release memeory for recursion call
        CPPerformArgument *argumentName = [self.syntaxOrderArguments objectAtIndex:CPPerformArgumentName];
        @autoreleasepool {
            [self.blockController.myStartupManager executeMyStartupsOfName:argumentName.startupName];
        }
    }

    atomic_fetch_add(&_recursionDepth, -1);
}

@end
