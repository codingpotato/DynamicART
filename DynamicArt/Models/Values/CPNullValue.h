//
//  CPNullValue.h
//  DynamicArt
//
//  Created by wangyw on 4/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"
#import "CPValue.h"

@interface CPNullValue : NSObject <CPCacheItem, CPValue>

+ (CPNullValue *)null;

@end
