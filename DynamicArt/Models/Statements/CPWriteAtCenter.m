//
//  CPWriteAtCenter.m
//  DynamicArt
//
//  Created by Yongwu Wang on 6/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWriteAtCenter.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPStringValue.h"
#import "CPWriteCommand.h"

typedef enum {
    CPWriteAtCenterNext,
    CPWriteAtCenterNumberOfSockets
} CPWriteAtCenterSockets;

typedef enum {
    CPWriteAtCenterArgumentText,
    CPWriteAtCenterArgumentX,
    CPWriteAtCenterArgumentY,
    CPWriteAtCenterNumberOfArguments
} CPWriteAtCenterArguments;

@implementation CPWriteAtCenter

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPStringValue valueWithString:@"Hello World"], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPWriteAtCenterNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPWriteCommand *command = [[CPWriteCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentText = [self.syntaxOrderArguments objectAtIndex:CPWriteAtCenterArgumentText];
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPWriteAtCenterArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPWriteAtCenterArgumentY];
    command.text = [argumentText calculateResult].stringValue;
    command.position = CGPointMake([argumentX calculateResult].doubleValue, [argumentY calculateResult].doubleValue);
    command.isPositionCenter = YES;
    [self.blockController sendUiCommand:command];
}

@end
