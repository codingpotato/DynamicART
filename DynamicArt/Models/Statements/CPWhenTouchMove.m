//
//  CPWhileTouchMove.m
//  DynamicArt
//
//  Created by wangyw on 4/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWhenTouchMove.h"

#import "CPBlockConfiguration.h"
#import "CPVariableManager.h"

typedef enum {
    CPWhileTouchMoveSocketNext,
    CPWhileTouchMoveNumberOfSockets
} CPWhileTouchMoveSockets;

typedef enum {
    CPWhileTouchMoveNumberOfArguments
} CPWhileTouchMoveArguments;

@implementation CPWhenTouchMove

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorGreen numberOfSockets:CPWhileTouchMoveNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

@end
