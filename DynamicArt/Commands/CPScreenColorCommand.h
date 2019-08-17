//
//  CPScreenColorCommand.h
//  DynamicArt
//
//  Created by wangyw on 11/24/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@class CPColorValue;

@interface CPScreenColorCommand : CPCommand

@property (nonatomic) CGPoint position;

@property (strong, nonatomic) CPColorValue *colorValue;

@end
