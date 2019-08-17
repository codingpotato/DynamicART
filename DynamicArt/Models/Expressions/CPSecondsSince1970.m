//
//  CPSecondsSince1970.m
//  DynamicArt
//
//  Created by wangyw on 5/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSecondsSince1970.h"

#import "CPBlockConfiguration.h"
#import "CPNumberValue.h"

@implementation CPSecondsSince1970

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    return [CPNumberValue valueWithDouble:[[NSDate alloc] init].timeIntervalSince1970];
}

@end
