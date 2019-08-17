//
//  CPMoveToCommand.h
//  DynamicArt
//
//  Created by wangyw on 3/28/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPMoveToCommand : CPCommand

@property (nonatomic) CGPoint target;

@end
