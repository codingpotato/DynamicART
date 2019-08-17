//
//  CPHour.m
//  DynamicArt
//
//  Created by wangyw on 5/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPHour.h"

#import "CPBlockConfiguration.h"
#import "CPNumberValue.h"

@implementation CPHour

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [CPCache emptyArray];
    NSArray *defaultValueOfArguments = [CPCache emptyArray];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPNumberValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate new]];
    return [CPNumberValue valueWithDouble:dateComponents.hour];
}

@end
