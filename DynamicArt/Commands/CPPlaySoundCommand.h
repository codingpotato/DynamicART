//
//  CPPlaySoundCommand.h
//  DynamicArt
//
//  Created by wangyw on 11/26/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPPlaySoundCommand : CPCommand

@property (nonatomic) float frequency;

@property (nonatomic) float interval;

@property (weak, nonatomic) NSCondition *condition;

@end
