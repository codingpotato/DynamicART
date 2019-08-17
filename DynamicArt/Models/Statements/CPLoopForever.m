//
//  CPLoopForever.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLoopForever.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPException.h"

typedef enum {
    CPLoopForeverSocketInner,
    CPLoopForeverSocketNext,
    CPLoopForeverNumberOfSockets
} CPLoopForeverSockets;

typedef enum {
    CPLoopForeverNumberOfArguments
} CPLoopForeverArguments;

@implementation CPLoopForever

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorOrange numberOfSockets:CPLoopForeverNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    while (YES) {
        @autoreleasepool {
            if (self.blockController.isForceQuit) {
                break;
            }
            @try {
                [self executeAllNextStatementsAtIndex:CPLoopForeverSocketInner];
            } @catch (CPBreakException *exception) {
                break;
            } @catch (CPContinueException *exception) {
                continue;
            }
        }
    }
}

@end
