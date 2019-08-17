//
//  CPArc.m
//  DynamicArt
//
//  Created by wangyw on 4/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArc.h"

#import "CPArcCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPArcSocketNext,
    CPArcNumberOfSockets
} CPArcSockets;

typedef enum {
    CPArcArgumentX,
    CPArcArgumentY,
    CPArcArgumentRadius,
    CPArcArgumentStartAngle,
    CPArcArgumentEndAngle,
    CPArcNumberOfArguments
} CPArcArguments;

@implementation CPArc

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:50.0], [CPNumberValue valueWithDouble:0.0],  [CPNumberValue valueWithDouble:360.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPArcNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPArcCommand *command = [[CPArcCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPArcArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPArcArgumentY];
    CPRightValueStrongTypeArgument *argumentRadius = [self.syntaxOrderArguments objectAtIndex:CPArcArgumentRadius];
    CPRightValueStrongTypeArgument *argumentStartAngle = [self.syntaxOrderArguments objectAtIndex:CPArcArgumentStartAngle];
    CPRightValueStrongTypeArgument *argumentEndAngle = [self.syntaxOrderArguments objectAtIndex:CPArcArgumentEndAngle];
    command.x = [argumentX calculateResult].doubleValue;
    command.y = [argumentY calculateResult].doubleValue;
    command.radius = [argumentRadius calculateResult].doubleValue;    
    command.startAngle = [argumentStartAngle calculateResult].doubleValue;
    command.endAngle = [argumentEndAngle calculateResult].doubleValue;
    [self.blockController sendUiCommand:command];
}

@end
