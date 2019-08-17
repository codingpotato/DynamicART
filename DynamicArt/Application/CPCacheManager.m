//
//  CPCacheManager.m
//  DynamicArt
//
//  Created by wangyw on 5/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"

@implementation CPCache

static NSArray *_emptyArray;

+ (NSArray *)emptyArray {
    if (!_emptyArray) {
        _emptyArray = [[NSArray alloc] init];
        [CPCacheManager addCachedClass:self];
    }
    return _emptyArray;
}

+ (void)releaseCache {
    _emptyArray = nil;
}

@end

@interface CPCacheManager ()

@property (strong, nonatomic) NSMutableArray *cacheClasses;

+ (CPCacheManager *)defaultCacheManager;

@end

@implementation CPCacheManager

static CPCacheManager *_defaultCacheManager;

+ (CPCacheManager *)defaultCacheManager {
    if (!_defaultCacheManager) {
        _defaultCacheManager = [[CPCacheManager alloc] init];
    }
    return _defaultCacheManager;
}

+ (void)addCachedClass:(Class<CPCacheItem>)cachedClass {
    [[CPCacheManager defaultCacheManager] addCachedClass:cachedClass];
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification {
    for (Class<CPCacheItem> cachedClass in self.cacheClasses) {
        [cachedClass releaseCache];
    }
    _defaultCacheManager = nil;
}

- (NSMutableArray *)cacheClasses {
    if (!_cacheClasses) {
        _cacheClasses = [[NSMutableArray alloc] init];
    }
    return _cacheClasses;
}

- (void)addCachedClass:(Class<CPCacheItem>)cachedClass {
    if (![self.cacheClasses containsObject:cachedClass]) {
        [self.cacheClasses addObject:cachedClass];
    }
}

@end
