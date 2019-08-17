//
//  CPSetColorCommand.h
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPSetColorCommand : CPCommand

@property (strong, nonatomic) UIColor *lineColor;

@property (strong, nonatomic) UIColor *fillColor;

@end
