//
//  CPSecond.m
//  DynamicArt
//
//  Created by wangyw on 5/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSecond.h"

#import "CPBlockConfiguration.h"
#import "CPNumberValue.h"

@implementation CPSecond

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:[NSDate new]];
    return [CPNumberValue valueWithDouble:dateComponents.second];
}

@end
