//
//  CPLoopFromToStep.m
//  DynamicArt
//
//  Created by wangyw on 3/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLoopFromToStep.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPException.h"
#import "CPHeadStatement.h"
#import "CPLeftValueArgument.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPVariableManager.h"

typedef enum {
    CPLoopFromToStepSocketInner,
    CPLoopFromToStepSocketNext,
    CPLoopFromToStepNumberOfSockets
} CPLoopFromToStepSockets;

typedef enum {
    CPLoopFromToStepArgumentVariable,
    CPLoopFromToStepArgumentFrom,
    CPLoopFromToStepArgumentTo,
    CPLoopFromToStepArgumentStep,
    CPLoopFromToStepNumberOfArguments
} CPLoopFromToStepArguments;

@implementation CPLoopFromToStep

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPLeftValueArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], [CPNumberValue valueWithDouble:1.0], [CPNumberValue valueWithDouble:10.0],  [CPNumberValue valueWithDouble:1.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorOrange numberOfSockets:CPLoopFromToStepNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPLeftValueArgument *argumentVariable = [self.syntaxOrderArguments objectAtIndex:CPLoopFromToStepArgumentVariable];
    CPRightValueStrongTypeArgument *argumentFrom = [self.syntaxOrderArguments objectAtIndex:CPLoopFromToStepArgumentFrom];
    CPRightValueStrongTypeArgument *argumentTo = [self.syntaxOrderArguments objectAtIndex:CPLoopFromToStepArgumentTo];
    CPRightValueStrongTypeArgument *argumentStep = [self.syntaxOrderArguments objectAtIndex:CPLoopFromToStepArgumentStep];
    
    double from = [argumentFrom calculateResult].doubleValue;
    double to = [argumentTo calculateResult].doubleValue;
    double step = [argumentStep calculateResult].doubleValue;
    int sign = (step == 0) ? 0 : (step > 0 ? 1 : -1);
    for (double loopVariable = from; loopVariable * sign <= to * sign; loopVariable += step) {
        @autoreleasepool {
            if (self.blockController.isForceQuit) {
                break;
            }
            [self.blockController.variableManager setValue:[CPNumberValue valueWithDouble:loopVariable] forVariable:argumentVariable.variableName];
            @try {
                [self executeAllNextStatementsAtIndex:CPLoopFromToStepSocketInner];
            } @catch (CPBreakException *exception) {
                break;
            } @catch (CPContinueException *exception) {
                continue;
            }
        }
    }
}

@end
