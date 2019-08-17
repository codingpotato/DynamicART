//
//  CPArcCommand.h
//  DynamicArt
//
//  Created by wangyw on 4/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPArcCommand : CPCommand

@property (nonatomic) CGFloat x, y, radius, startAngle, endAngle;

@end
