//
//  CPBlockMockup.m
//  DynamicArt
//
//  Created by 咏武 王 on 3/12/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPStatementMockup.h"

@implementation CPStatementMockup

@synthesize sizeChangedArgument = _sizeChangedArgument, deltaSizeOfArgument = _deltaSize;

static CPBlockConfigurationColor _color;

static BOOL _headOfBlocks;

static int _numberOfSockets;

+ (void)setExpectedColor:(CPBlockConfigurationColor)color {
    _color = color;
}

+ (void)setExpectedHeadOfBlocks:(BOOL)headOfBlocks {
    _headOfBlocks = headOfBlocks;
}

+ (void)setExpectedNumberOfSockets:(int)numberOfSockets {
    _numberOfSockets = numberOfSockets;
}

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray array];
    NSArray *defaultValueOfArguments = [NSArray array];
    return [[CPBlockConfiguration alloc] initWithStatementClass:self.class color:_color numberOfSockets:_numberOfSockets syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (void)argument:(CPArgument *)argument sizeChanged:(CGSize)deltaSize {
    self.sizeChangedArgument = argument;
    self.deltaSizeOfArgument = deltaSize;
}

@end
