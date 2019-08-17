//
//  CPPoint.m
//  DynamicArt
//
//  Created by wangyw on 4/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPoint.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPPointCommand.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPPointSocketNext,
    CPPointNumberOfSockets
} CPPointSockets;

typedef enum {
    CPPointArgumentX,
    CPPointArgumentY,
    CPPointNumberOfArguments
} CPPointArguments;

@implementation CPPoint

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPPointNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPPointArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPPointArgumentY];
    CPPointCommand *command = [[CPPointCommand alloc] init];
    command.position = CGPointMake([argumentX calculateResult].doubleValue, [argumentY calculateResult].doubleValue);
    [self.blockController sendUiCommand:command];
}

@end
