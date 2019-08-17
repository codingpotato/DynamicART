//
//  CPForwardCommand.h
//  DynamicArt
//
//  Created by wangyw on 3/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPMoveCommand : CPCommand

@property (nonatomic) int direction;

@property (nonatomic) CGFloat step;

@end
