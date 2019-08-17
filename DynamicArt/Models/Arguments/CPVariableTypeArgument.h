//
//  CPVariableTypeArgument.h
//  DynamicArt
//
//  Created by wangyw on 11/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"
#import "CPListArgument.h"

typedef enum {
    CPVariableTypeBoolean,
    CPVariableTypeColor,
    CPVariableTypeNumber,
    CPVariableTypeString,
    CPVariableTypeNumberOfTypes
} CPVariableType;

@interface CPVariableTypeArgument : CPListArgument <CPCacheItem>

@end
