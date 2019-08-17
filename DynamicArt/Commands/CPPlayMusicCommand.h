//
//  CPPlayMusic.h
//  DynamicArt
//
//  Created by wangyw on 12/1/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPPlayMusicCommand : CPCommand

@property (strong, nonatomic) NSString *musicString;

@property (weak, nonatomic) NSCondition *condition;

@end
