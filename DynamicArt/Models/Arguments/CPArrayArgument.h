//
//  CPArrayArgument.h
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgument.h"

@interface CPArrayArgument : CPArgument

@property (strong, nonatomic) NSString *arrayName;

- (void)updateArrayName:(NSString *)arrayName;

@end
