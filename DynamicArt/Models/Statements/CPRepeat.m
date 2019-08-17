//
//  CPRepeat.m
//  DynamicArt
//
//  Created by wangyw on 12-3-1.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

#import "CPRepeat.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPException.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPRepeatSocketInner,
    CPRepeatSocketNext,
    CPRepeatNumberOfSockets
} CPRepeatSockets;

typedef enum {
    CPRepeatArgumentTimes,
    CPRepeatNumberOfArguments
} CPRepeatArguments;

@implementation CPRepeat

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:10.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorOrange numberOfSockets:CPRepeatNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {    
    CPRightValueStrongTypeArgument *argumentTimes = [self.syntaxOrderArguments objectAtIndex:CPRepeatArgumentTimes];
    int loopTimes = [argumentTimes calculateResult].intValue;
    
    for (int loopVariable = 0; loopVariable < loopTimes; loopVariable++) {
        @autoreleasepool {
            if (self.blockController.isForceQuit) {
                break;
            }
            @try {
                [self executeAllNextStatementsAtIndex:CPRepeatSocketInner];
            } @catch (CPBreakException *exception) {
                break;
            } @catch (CPContinueException *exception) {
                continue;
            }
        }
    }
}

@end
