//
//  CPTurnLeftCommamd.h
//  DynamicArt
//
//  Created by wangyw on 3/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPTurnCommand : CPCommand

@property (nonatomic) int direction;

@property (nonatomic) CGFloat angle;

@end
