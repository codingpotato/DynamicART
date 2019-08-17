//
//  CPRect.m
//  DynamicArt
//
//  Created by wangyw on 3/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRect.h"

#import "CPRectCommand.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPRectSocketNext,
    CPRectNumberOfSockets
} CPRectSockets;

typedef enum {
    CPRectArgumentX,
    CPRectArgumentY,
    CPRectArgumentWidth,
    CPRectArgumentHeight,
    CPRectNumberOfArguments
} CPRectArguments;

@implementation CPRect

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:200.0],  [CPNumberValue valueWithDouble:200.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPRectNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPRectCommand *command = [[CPRectCommand alloc] init];
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPRectArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPRectArgumentY];
    CPRightValueStrongTypeArgument *argumentWidth = [self.syntaxOrderArguments objectAtIndex:CPRectArgumentWidth];
    CPRightValueStrongTypeArgument *argumentHeight = [self.syntaxOrderArguments objectAtIndex:CPRectArgumentHeight];
    command.rect = CGRectMake([argumentX calculateResult].doubleValue, [argumentY calculateResult].doubleValue, [argumentWidth calculateResult].doubleValue, [argumentHeight calculateResult].doubleValue);
    [self.blockController sendUiCommand:command];
}

@end
