//
//  CPDisplayCommand.h
//  DynamicArt
//
//  Created by wangyw on 3/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCommand.h"

@interface CPWriteCommand : CPCommand

@property (nonatomic) NSString *text;

@property (nonatomic) CGPoint position;

@property (nonatomic) BOOL isPositionCenter;

@end
