//
//  CPRandomColor.m
//  DynamicArt
//
//  Created by wangyw on 4/8/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRandomColor.h"

#import "CPBlockConfiguration.h"
#import "CPColorValue.h"

@implementation CPRandomColor

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPColorValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    u_int32_t max = CPColorValueComponentMax + 1;
    NSUInteger red = arc4random() % max;
    NSUInteger green = arc4random() % max;
    NSUInteger blue = arc4random() % max;
    NSUInteger alpha = arc4random() % max;
    return [CPColorValue valueWithRed:red green:green blue:blue alpha:alpha];
}

@end
