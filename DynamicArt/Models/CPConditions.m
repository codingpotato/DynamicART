//
//  CPConditions.m
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPConditions.h"

#import "CPTrace.h"

@interface CPConditions ()

@property (strong, nonatomic) NSMutableArray *conditions;

@property (strong, nonatomic) NSCondition *waitForTouchCondition;

@end

@implementation CPConditions

- (NSMutableArray *)conditions {
    if (!_conditions) {
        _conditions = [[NSMutableArray alloc] init];
    }
    return _conditions;
}

- (NSCondition *)waitingForTouchCondition {
    if (!_waitForTouchCondition) {
        _waitForTouchCondition = [[NSCondition alloc] init];
    }
    return _waitForTouchCondition;
}

- (void)waitForTouch {
    [self.waitForTouchCondition lock];
    [self.waitForTouchCondition wait];
    [self.waitForTouchCondition unlock];
}

- (void)broadcastTouch {
    [self.waitForTouchCondition lock];
    [self.waitForTouchCondition broadcast];
    [self.waitForTouchCondition unlock];
}

- (NSCondition *)allocateCondition {
    NSCondition *condition = [[NSCondition alloc] init];
    [self.conditions addObject:condition];
    return condition;
}

- (void)waitForCondition:(NSCondition *)condition {
    if ([self.conditions containsObject:condition]) {
        [condition lock];
        [condition wait];
        [condition unlock];
    }
}

- (void)signalCondition:(NSCondition *)condition {
    if ([self.conditions containsObject:condition]) {
        [condition lock];
        [condition signal];
        [condition unlock];
        [self.conditions removeObject:condition];
    }
}

- (void)stopExecute {
    [self broadcastTouch];
    for (NSCondition *condition in self.conditions) {
        [condition lock];
        [condition signal];
        [condition unlock];
    }
}

- (void)dealloc {
    CPTrace(@"%@ dealloc", self);
}

@end
