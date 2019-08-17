//
//  CPWriteAtOrigin.m
//  DynamicArt
//
//  Created by wangyw on 3/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWriteAtOrigin.h"

#import "CPWriteCommand.h"

#import "CPBLockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPStringValue.h"

typedef enum {
    CPWriteAtOriginNext,
    CPWriteAtOriginNumberOfSockets
} CPWriteAtOriginSockets;

typedef enum {
    CPWriteAtOriginArgumentText,
    CPWriteAtOriginArgumentX,
    CPWriteAtOriginArgumentY,
    CPWriteAtOriginNumberOfArguments
} CPWriteAtOriginArguments;

@implementation CPWriteAtOrigin

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPStringValue valueWithString:@"Hello World"], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPWriteAtOriginNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPWriteCommand *command = [[CPWriteCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentText = [self.syntaxOrderArguments objectAtIndex:CPWriteAtOriginArgumentText];
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPWriteAtOriginArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPWriteAtOriginArgumentY];
    command.text = [argumentText calculateResult].stringValue;
    command.position = CGPointMake([argumentX calculateResult].doubleValue, [argumentY calculateResult].doubleValue);
    command.isPositionCenter = NO;
    [self.blockController sendUiCommand:command];
}

@end
