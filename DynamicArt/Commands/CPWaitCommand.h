//
//  CPWaitCommand.h
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPWaitCommand : CPCommand

@property (weak, nonatomic) NSCondition *condition;

@property (nonatomic) NSTimeInterval interval;

@end
