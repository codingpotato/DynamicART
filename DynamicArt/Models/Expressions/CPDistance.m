//
//  CPDistance.m
//  DynamicArt
//
//  Created by wangyw on 10/3/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPDistance.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPDistanceArgumentX1,
    CPDistanceArgumentY1,
    CPDistanceArgumentX2,
    CPDistanceArgumentY2,
    CPDistanceNumberOfArguments
} CPDistanceArguments;

@implementation CPDistance

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:200.0], [CPNumberValue valueWithDouble:200.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argumentX1 = [self.syntaxOrderArguments objectAtIndex:CPDistanceArgumentX1];
    CPRightValueStrongTypeArgument *argumentY1 = [self.syntaxOrderArguments objectAtIndex:CPDistanceArgumentY1];
    CPRightValueStrongTypeArgument *argumentX2 = [self.syntaxOrderArguments objectAtIndex:CPDistanceArgumentX2];
    CPRightValueStrongTypeArgument *argumentY2 = [self.syntaxOrderArguments objectAtIndex:CPDistanceArgumentY2];
    double deltaX = [argumentX1 calculateResult].doubleValue - [argumentX2 calculateResult].doubleValue;
    double deltaY = [argumentY1 calculateResult].doubleValue - [argumentY2 calculateResult].doubleValue;
    double result = sqrt(deltaX * deltaX + deltaY * deltaY);
    return [CPNumberValue valueWithDouble:result];
}

@end
