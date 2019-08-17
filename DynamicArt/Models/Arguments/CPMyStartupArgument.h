//
//  CPMyStartupArgument.h
//  DynamicArt
//
//  Created by wangyw on 10/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgument.h"

@interface CPMyStartupArgument : CPArgument

@property (strong, nonatomic) NSString *startupName;

- (void)updateStartupName:(NSString *)startupName;

@end
