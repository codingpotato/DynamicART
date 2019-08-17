//
//  CPConditions.h
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@interface CPConditions : NSObject

- (void)waitForTouch;

- (void)broadcastTouch;

- (NSCondition *)allocateCondition;

- (void)waitForCondition:(NSCondition *)condition;

- (void)signalCondition:(NSCondition *)condition;

- (void)stopExecute;

@end
