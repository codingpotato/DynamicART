//
//  CPBooleanValue.m
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBooleanValue.h"

#import "CPCacheManager.h"
#import "CPNumberValue.h"

@interface CPBooleanValue () {
    BOOL _booleanValue;
}

- (id)initWithBoolean:(BOOL)booleanValue;

@end

@implementation CPBooleanValue

static CPBooleanValue *_true, *_false;

+ (CPBooleanValue *)valueWithBoolean:(BOOL)booleanValue {
    return booleanValue ? self.trueValue : self.falseValue;
}

static NSArray *_booleanConstants;

+ (CPBooleanValue *)trueValue {
    if (!_true) {
        _true = [[CPBooleanValue alloc] initWithBoolean:YES];
        [CPCacheManager addCachedClass:self];
    }
    return _true;
}

+ (CPBooleanValue *)falseValue {
    if (!_false) {
        _false = [[CPBooleanValue alloc] initWithBoolean:NO];
        [CPCacheManager addCachedClass:self];
    }
    return _false;
}

+ (NSArray *)booleanConstants {
    if (!_booleanConstants) {
        _booleanConstants = [NSArray arrayWithObjects:[CPBooleanValue trueValue].stringValue, [CPBooleanValue falseValue].stringValue, nil];
        [CPCacheManager addCachedClass:self];
    }
    return _booleanConstants;
}

- (id)initWithBoolean:(BOOL)booleanValue {
    self = [super init];
    if (self) {
        _booleanValue = booleanValue;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _booleanValue = [aDecoder decodeBoolForKey:CPValueEncodingKeyValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:_booleanValue forKey:CPValueEncodingKeyValue];
}

- (int)intValue {
    return _booleanValue ? 1 : 0;
}

- (double)doubleValue {
    return self.intValue;
}

- (NSString *)stringValue {
    return _booleanValue ? @"True" : @"False";
}

- (BOOL)booleanValue {
    return _booleanValue;
}

- (UIColor *)uiColor {
    return _booleanValue ? [UIColor whiteColor] : [UIColor blackColor];
}

- (unichar)headTag {
    return 0;
}

- (unichar)tailTag {
    return 0;
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    _true = nil;
    _false = nil;
    _booleanConstants = nil;
}

@end
