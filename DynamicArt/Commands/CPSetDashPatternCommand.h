//
//  CPSetDashPatternCommand.h
//  DynamicArt
//
//  Created by wangyw on 11/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPSetDashPatternCommand : CPCommand

@property (nonatomic) CGFloat paintLength;

@property (nonatomic) CGFloat unpaintLength;

@end
