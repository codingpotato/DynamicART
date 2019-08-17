//
//  CPMathFunction.m
//  DynamicArt
//
//  Created by wangyw on 3/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMathFunction.h"

#import "CPBlockConfiguration.h"
#import "CPMathFunctionArgument.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPMathFunctionArgument1,
    CPMathFunctionArgument2,
    CPMathFunctionNumberOfArguments
} CPMathFunctionArguments;

static inline double radianOfAngle(double angle) {
    return angle * M_PI / 180.0;
}

static inline double angleOfRadian(double radian) {
    return radian * 180.0 / M_PI;
}

@implementation CPMathFunction

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPMathFunctionArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPMathFunctionArgument *argument1 = [self.syntaxOrderArguments objectAtIndex:CPMathFunctionArgument1];
    CPRightValueStrongTypeArgument *argument2 = [self.syntaxOrderArguments objectAtIndex:CPMathFunctionArgument2];
    
    double value = [argument2 calculateResult].doubleValue;
    switch (argument1.index) {
        case CPMathFunctionArgumentTypeAbs:
            return [CPNumberValue valueWithDouble:fabs(value)];
        case CPMathFunctionArgumentTypeSqrt:
            value = fmax(value, 0.0);
            return [CPNumberValue valueWithDouble:sqrt(value)];
        case CPMathFunctionArgumentTypeSin:
            return [CPNumberValue valueWithDouble:sin(radianOfAngle(value))];
        case CPMathFunctionArgumentTypeCos:
            return [CPNumberValue valueWithDouble:cos(radianOfAngle(value))];
        case CPMathFunctionArgumentTypeTan:
            return [CPNumberValue valueWithDouble:tan(radianOfAngle(value))];
        case CPMathFunctionArgumentTypeAsin:
            value = fmax(value, -1.0);
            value = fmin(value, 1.0);
            return [CPNumberValue valueWithDouble:angleOfRadian(asin(value))];
        case CPMathFunctionArgumentTypeAcos:
            value = fmax(value, -1.0);
            value = fmin(value, 1.0);
            return [CPNumberValue valueWithDouble:angleOfRadian(acos(value))];
        case CPMathFunctionArgumentTypeAtan:
            return [CPNumberValue valueWithDouble:angleOfRadian(atan(value))];
        case CPMathFunctionArgumentTypeLn:
            value = fmax(value, 0.0);
            return [CPNumberValue valueWithDouble:log(value)];
        case CPMathFunctionArgumentTypeLog:
            value = fmax(value, 0.0);
            return [CPNumberValue valueWithDouble:log10(value)];
        case CPMathFunctionArgumentTypeRound:
            return [CPNumberValue valueWithDouble:round(value)];
        case CPMathFunctionArgumentTypeFloor:
            return [CPNumberValue valueWithDouble:floor(value)];
        case CPMathFunctionArgumentTypeCeil:
            return [CPNumberValue valueWithDouble:ceil(value)];
        default:
            NSAssert(NO, @"");
            return nil;
    }
}

@end
