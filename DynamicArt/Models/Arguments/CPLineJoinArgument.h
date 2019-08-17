//
//  CPLineJoinArgument.h
//  DynamicArt
//
//  Created by wangyw on 11/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"
#import "CPListArgument.h"

typedef enum {
    CPLineJoinTypeMiter,
    CPLineJoinTypeRound,
    CPLineJoinTypeBevel,
    CPLineJoinTypeNumberOfTypes
} CPLineJoinType;

@interface CPLineJoinArgument : CPListArgument <CPCacheItem>

@end
