//
//  CPListArgument.h
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgument.h"

@interface CPListArgument : CPArgument

@property (nonatomic) NSUInteger index;

- (NSArray *)listArray;

- (NSString *)currentText;

- (void)updateIndex:(NSUInteger)index;

@end
