//
//  CPNullValue.m
//  DynamicArt
//
//  Created by wangyw on 4/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPNullValue.h"

@implementation CPNullValue

static CPNullValue *_null;

+ (CPNullValue *)null {
    if (!_null) {
        _null = [[CPNullValue alloc] init];
        [CPCacheManager addCachedClass:self];
    }
    return _null;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (int)intValue {
    return 0;
}

- (double)doubleValue {
    return 0.0;
}

- (NSString *)stringValue {
    return nil;
}

- (BOOL)booleanValue {
    return NO;
}

- (UIColor *)uiColor {
    return nil;
}

- (unichar)headTag {
    return ' ' ;
}

- (unichar)tailTag {
    return ' ';
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    _null = nil;
}

@end
