//
//  CPDrawPolygen.m
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPolygen.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPPolygenCommand.h"
#import "CPNullValue.h"
#import "CPVariableManager.h"

typedef enum {
    CPDrawPolygenSocketNext,
    CPDrawPolygenNumberOfSockets
} CPDrawPolygenSockets;

typedef enum {
    CPDrawPolygenArgumentXList,
    CPDrawPolygenArgumentYList,
    CPDrawPolygenNumberOfArguments
} CPDrawPolygenArguments;

@implementation CPPolygen

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPArrayArgument class], [CPArrayArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNullValue null], [CPNullValue null], nil];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:CPBlockConfigurationColorBlue numberOfSockets:CPDrawPolygenNumberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)execute {
    CPArrayArgument *argumentXList = [self.syntaxOrderArguments objectAtIndex:CPDrawPolygenArgumentXList];
    CPArrayArgument *argumentYList = [self.syntaxOrderArguments objectAtIndex:CPDrawPolygenArgumentYList];
    int countX = (int)[self.blockController.variableManager countOfArrayVariable:argumentXList.arrayName];
    int countY = (int)[self.blockController.variableManager countOfArrayVariable:argumentYList.arrayName];
    int count = MIN(countX, countY);
    if (count >= 3) {
        CPVariableManager *variableManager = self.blockController.variableManager;
        CPPolygenCommand *command = [[CPPolygenCommand alloc] init];
        command.startPoint = CGPointMake([variableManager valueAtIndex:0 ofArrayVariable:argumentXList.arrayName].doubleValue, [variableManager valueAtIndex:0 ofArrayVariable:argumentYList.arrayName].doubleValue);
        command.points = [[NSMutableArray alloc] initWithCapacity:count - 1];
        for (int i = 1; i < count; i++) {
            CGPoint point = CGPointMake([variableManager valueAtIndex:i ofArrayVariable:argumentXList.arrayName].doubleValue, [variableManager valueAtIndex:i ofArrayVariable:argumentYList.arrayName].doubleValue);
            [command.points addObject:[NSValue valueWithCGPoint:point]];
        }
        
        [self.blockController sendUiCommand:command];
    }
}

@end
