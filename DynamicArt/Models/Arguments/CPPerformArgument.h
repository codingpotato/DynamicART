//
//  CPMyStartupPerformArgument.h
//  DynamicArt
//
//  Created by wangyw on 10/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgument.h"

@interface CPPerformArgument : CPArgument

@property (strong, nonatomic) NSString *startupName;

- (void)updateStartupName:(NSString *)startupName;

@end
