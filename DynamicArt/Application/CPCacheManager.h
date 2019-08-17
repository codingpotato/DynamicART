//
//  CPCacheManager.h
//  DynamicArt
//
//  Created by wangyw on 5/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPCacheItem <NSObject>

+ (void)releaseCache;

@end

@interface CPCache : NSObject <CPCacheItem>

+ (NSArray *)emptyArray;

@end

@interface CPCacheManager : NSObject

+ (void)addCachedClass:(Class<CPCacheItem>)cachedClass;

@end
