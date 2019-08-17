//
//  CPUntil.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPUntil.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPBooleanValue.h"
#import "CPException.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPUntilSocketInner,
    CPUntilSocketNext,
    CPUntilNumberOfSockets
} CPUntilSockets;

typedef enum {
    CPUntilArgument,
    CPUntilNumberOfArguments
} CPUntilArguments;

@implementation CPUntil

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPBooleanValue trueValue], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorOrange numberOfSockets:CPUntilNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {    
    CPRightValueStrongTypeArgument *argument = [self.syntaxOrderArguments objectAtIndex:CPUntilArgument];
    
    do {
        @autoreleasepool {
            if (self.blockController.isForceQuit) {
                break;
            }
            @try {
                [self executeAllNextStatementsAtIndex:CPUntilSocketInner];
            } @catch (CPBreakException *exception) {
                break;
            } @catch (CPContinueException *exception) {
                continue;
            }
        }
    } while (![argument calculateResult].booleanValue);
}

@end
