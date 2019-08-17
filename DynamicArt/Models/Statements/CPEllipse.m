//
//  CPEllipse.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPEllipse.h"

#import "CPEllipseCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPEllipseSocketNext,
    CPEllipseNumberOfSockets
} CPEllipseSockets;

typedef enum {
    CPEllipseArgumentCenterX,
    CPEllipseArgumentCenterY,
    CPEllipseArgumentHRadius,
    CPEllipseArgumentVRadius,
    CPEllipseNumberOfArguments
} CPEllipseArguments;

@implementation CPEllipse

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:50.0],  [CPNumberValue valueWithDouble:50.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPEllipseNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPEllipseCommand *command = [[CPEllipseCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentCenterX = [self.syntaxOrderArguments objectAtIndex:CPEllipseArgumentCenterX];
    CPRightValueStrongTypeArgument *argumentCenterY = [self.syntaxOrderArguments objectAtIndex:CPEllipseArgumentCenterY];
    CPRightValueStrongTypeArgument *argumentHRadius = [self.syntaxOrderArguments objectAtIndex:CPEllipseArgumentHRadius];
    CPRightValueStrongTypeArgument *argumentVRadius = [self.syntaxOrderArguments objectAtIndex:CPEllipseArgumentVRadius];
    command.rect = CGRectMake([argumentCenterX calculateResult].doubleValue - [argumentHRadius calculateResult].doubleValue, [argumentCenterY calculateResult].doubleValue - [argumentVRadius calculateResult].doubleValue, [argumentHRadius calculateResult].doubleValue * 2.0, [argumentVRadius calculateResult].doubleValue * 2.0);
    [self.blockController sendUiCommand:command];
}

@end
