//
//  CPNumberValue.m
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPNumberValue.h"

#import "CPColorValue.h"

NSString *CPValueEncodingKeyValue = @"Value";

@interface CPNumberValue ()

@property (nonatomic) double doubleValue;

- (id)initWithDouble:(double)doubleValue;

@end

@implementation CPNumberValue

+ (double)zeroTolerance {
    return 1e-8;
}

+ (CPNumberValue *) valueWithDouble:(double)doubleValue {
    return [[CPNumberValue alloc] initWithDouble:doubleValue];
}

- (id)initWithDouble:(double)doubleValue {
    self = [super init];
    if (self) {
        _doubleValue = doubleValue;
        if (isnan(_doubleValue)) {
            _doubleValue = 0.0;
        } else if (isinf(_doubleValue)) {
            _doubleValue = DBL_MAX;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _doubleValue = [aDecoder decodeDoubleForKey:CPValueEncodingKeyValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_doubleValue forKey:CPValueEncodingKeyValue];
}

- (int)intValue {
    return _doubleValue;
}

- (double)doubleValue {
    return _doubleValue;
}

- (NSString *)stringValue {
    return [[NSNumber numberWithDouble:_doubleValue] stringValue];
}

- (BOOL)booleanValue {
    return self.intValue != 0;
}

- (UIColor *)uiColor {
    int intValue = self.intValue;
    int redByte = intValue >> 24;
    int greenByte = (intValue & 0xffffff) >> 16;
    int blueByte = (intValue & 0xffff) >> 8;
    int alphaByte = intValue & 0xff;
    CGFloat red = (CGFloat)redByte / CPColorValueComponentMax;
    CGFloat green = (CGFloat)greenByte / CPColorValueComponentMax;
    CGFloat blue = (CGFloat)blueByte / CPColorValueComponentMax;
    CGFloat alpha = (CGFloat)alphaByte / CPColorValueComponentMax;
    return [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
}

- (unichar)headTag {
    return 0;
}

- (unichar)tailTag {
    return 0;
}

@end
