//
//  CPShowCommand.h
//  DynamicArt
//
//  Created by wangyw on 11/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPShowCommand : CPCommand

@property (nonatomic, getter = isShown) BOOL shown;

@end
