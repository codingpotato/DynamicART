//
//  CPStringValue.m
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPStringValue.h"

#import "CPColorValue.h"

@interface CPStringValue () {
@private
    NSString *_stringValue;
}

- (id)initWithString:(NSString *)stringValue;

@end

@implementation CPStringValue

+ (CPStringValue *)valueWithString:(NSString *)stringValue {
    return [[CPStringValue alloc] initWithString:stringValue];
}

- (id)initWithString:(NSString *)stringValue {
    self = [super init];
    if (self) {
        _stringValue = stringValue;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _stringValue = [aDecoder decodeObjectForKey:CPValueEncodingKeyValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stringValue forKey:CPValueEncodingKeyValue];
}

- (int)intValue {
    return _stringValue.intValue;
}

- (double)doubleValue {
    return _stringValue.doubleValue;
}

- (NSString *)stringValue {
    return _stringValue;
}

- (BOOL)booleanValue {
    return [[_stringValue lowercaseString] isEqualToString:@"true"];
}

- (UIColor *)uiColor {
    if (_stringValue.length == 8) {
        int redByte = hexByte(_stringValue, 0);
        int greenByte = hexByte(_stringValue, 2);
        int blueByte = hexByte(_stringValue, 4);
        int alphaByte = hexByte(_stringValue, 6);
        CGFloat red = (CGFloat)redByte / CPColorValueComponentMax;
        CGFloat green = (CGFloat)greenByte / CPColorValueComponentMax;
        CGFloat blue = (CGFloat)blueByte / CPColorValueComponentMax;
        CGFloat alpha = (CGFloat)alphaByte / CPColorValueComponentMax;
        return [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
    } else {
        return [UIColor blackColor];
    }
}

- (unichar)headTag {
    return '"';
}

- (unichar)tailTag {
    return '"';
}

static inline int hexDigit(NSString *string, int index) {
    unichar ch = [string characterAtIndex:index];
    if (ch >= '0' && ch <= '9') {
        return ch - '0';
    } else if (ch >= 'a' && ch <= 'f') {
        return ch - 'a' + 10;
    } else if (ch >= 'A' && ch <= 'F') {
        return ch - 'A' + 10;
    } else {
        return 0;
    }
}

static inline int hexByte(NSString *string, int index) {
    int hexHigh = hexDigit(string, index);
    int hexLow = hexDigit(string, index + 1);
    return (hexHigh << 4) | hexLow;
}

@end
