//
//  CPCurveCommand.h
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPCurveCommand : CPCommand

@property (nonatomic) CGPoint point1, point2, controlPoint1, controlPoint2;

@end
