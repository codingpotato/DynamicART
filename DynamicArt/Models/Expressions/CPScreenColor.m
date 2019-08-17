//
//  CPScreenColor.m
//  DynamicArt
//
//  Created by wangyw on 11/24/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPScreenColor.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPColorValue.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPScreenColorCommand.h"

typedef enum {
    CPScreenColorArgumentX,
    CPScreenColorArgumentY,
    CPScreenColorNumberOfArguments
} CPScreenColorArguments;

@implementation CPScreenColor

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPColorValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPScreenColorArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPScreenColorArgumentY];
    CPScreenColorCommand *command = [[CPScreenColorCommand alloc] init];
    command.position = CGPointMake([argumentX calculateResult].doubleValue, [argumentY calculateResult].doubleValue);
    [self.blockController sendUiCommand:command];
    return command.colorValue;
}

@end
