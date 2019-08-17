//
//  CPDrawPolygenCommand.h
//  DynamicArt
//
//  Created by wangyw on 12/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPPolygenCommand : CPCommand

@property (nonatomic) CGPoint startPoint;

@property (strong, nonatomic) NSMutableArray *points;

@end
