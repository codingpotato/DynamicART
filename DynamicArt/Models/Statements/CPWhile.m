//
//  CPWhile.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWhile.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPBooleanValue.h"
#import "CPException.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPWhileSocketInner,
    CPWhileSocketNext,
    CPWhileNumberOfSockets
} CPWhileSockets;

typedef enum {
    CPWhileArgument,
    CPWhileNumberOfArguments
} CPWhileArguments;

@implementation CPWhile

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPBooleanValue trueValue], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorOrange numberOfSockets:CPWhileNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {    
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPWhileArgument];
    
    while ([argument calculateResult].booleanValue) {
        @autoreleasepool {
            if (self.blockController.isForceQuit) {
                break;
            }
            @try {
                [self executeAllNextStatementsAtIndex:CPWhileSocketInner];
            } @catch (CPBreakException *exception) {
                break;
            } @catch (CPContinueException *exception) {
                continue;
            }
        }
    }
}

@end
