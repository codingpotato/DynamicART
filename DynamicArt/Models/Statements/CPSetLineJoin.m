//
//  CPSetLineJoin.m
//  DynamicArt
//
//  Created by wangyw on 11/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSetLineJoin.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPLineJoinArgument.h"
#import "CPNumberValue.h"
#import "CPSetLineJoinCommand.h"

typedef enum {
    CPSetLineJoinNext,
    CPSetLineJoinNumberOfSockets
} CPSetLineJoinSockets;

typedef enum {
    CPSetLineJoinArgumentType,
    CPSetLineJoinNumberOfArguments
} CPSetLineJoinArguments;

@implementation CPSetLineJoin

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPLineJoinArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPSetLineJoinNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPLineJoinArgument *argumentType = [self.syntaxOrderArguments objectAtIndex:CPSetLineJoinArgumentType];
    CPSetLineJoinCommand *command = [[CPSetLineJoinCommand alloc] init];
    switch (argumentType.index) {
        case CPLineJoinTypeMiter:
            command.lineJoin = kCGLineJoinMiter;
            break;
        case CPLineJoinTypeRound:
            command.lineJoin = kCGLineJoinRound;
            break;
        case CPLineJoinTypeBevel:
            command.lineJoin = kCGLineJoinBevel;
            break;
        default:
            NSAssert(NO, @"");
            break;
    }
    [self.blockController sendUiCommand:command];
}

@end
