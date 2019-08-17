//
//  CPPenCommand.h
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPPenCommand : CPCommand

@property (nonatomic, getter = isPenDown) BOOL penDown;

@end
