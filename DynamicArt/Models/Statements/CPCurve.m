//
//  CPCurve.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCurve.h"

#import "CPCurveCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPCurveSocketNext,
    CPCurveNumberOfSockets
} CPCurveSockets;

typedef enum {
    CPCurveArgumentX1,
    CPCurveArgumentY1,
    CPCurveArgumentControlX1,
    CPCurveArgumentControlY1,
    CPCurveArgumentX2,
    CPCurveArgumentY2,
    CPCurveArgumentControlX2,
    CPCurveArgumentControlY2,
    CPCurveNumberOfArguments
} CPCurveArguments;

@implementation CPCurve

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:200.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:200.0],  [CPNumberValue valueWithDouble:200.0], [CPNumberValue valueWithDouble:100.0],  [CPNumberValue valueWithDouble:200.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPCurveNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPCurveCommand *command = [[CPCurveCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentX1 = [self.syntaxOrderArguments objectAtIndex:CPCurveArgumentX1];
    CPRightValueStrongTypeArgument *argumentY1 = [self.syntaxOrderArguments objectAtIndex:CPCurveArgumentY1];
    CPRightValueStrongTypeArgument *argumentX2 = [self.syntaxOrderArguments objectAtIndex:CPCurveArgumentX2];
    CPRightValueStrongTypeArgument *argumentY2 = [self.syntaxOrderArguments objectAtIndex:CPCurveArgumentY2];
    CPRightValueStrongTypeArgument *argumentControlX1 = [self.syntaxOrderArguments objectAtIndex:CPCurveArgumentControlX1];
    CPRightValueStrongTypeArgument *argumentControlY1 = [self.syntaxOrderArguments objectAtIndex:CPCurveArgumentControlY1];
    CPRightValueStrongTypeArgument *argumentControlX2 = [self.syntaxOrderArguments objectAtIndex:CPCurveArgumentControlX2];
    CPRightValueStrongTypeArgument *argumentControlY2 = [self.syntaxOrderArguments objectAtIndex:CPCurveArgumentControlY2];
    command.point1 = CGPointMake([argumentX1 calculateResult].doubleValue, [argumentY1 calculateResult].doubleValue);
    command.point2 = CGPointMake([argumentX2 calculateResult].doubleValue, [argumentY2 calculateResult].doubleValue);
    command.controlPoint1 = CGPointMake([argumentControlX1 calculateResult].doubleValue, [argumentControlY1 calculateResult].doubleValue);
    command.controlPoint2 = CGPointMake([argumentControlX2 calculateResult].doubleValue, [argumentControlY2 calculateResult].doubleValue);
    [self.blockController sendUiCommand:command];
}

@end
