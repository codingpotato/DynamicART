//
//  CPColorValue.m
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPColorValue.h"

#import "CPBooleanValue.h"
#import "CPNumberValue.h"

static NSString *CPColorValueEncodingKeyIsHSBA = @"IsHSBA";
static NSString *CPColorValueEncodingKeyRed = @"Red";
static NSString *CPColorValueEncodingKeyGreen = @"Green";
static NSString *CPColorValueEncodingKeyBlue = @"Blue";
static NSString *CPColorValueEncodingKeyHue = @"Hue";
static NSString *CPColorValueEncodingKeySaturation = @"Saturation";
static NSString *CPColorValueEncodingKeyBrightness = @"Brightness";
static NSString *CPColorValueEncodingKeyAlpha = @"Alpha";

@interface CPColorValue ()

@property (strong, nonatomic) UIColor *uiColor;

- (id)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;

- (id)initWithHue:(NSInteger)hue saturation:(NSInteger)saturation brightness:(NSInteger)brightness alpha:(NSInteger)alpha;

- (id)initWithUIColor:(UIColor *)uiColor;

- (void)generateRBG;

- (void)generateHSB;

@end

@implementation CPColorValue

+ (CPColorValue *)valueWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha {
    return [[CPColorValue alloc] initWithRed:red green:green blue:blue alpha:alpha];
}

+ (CPColorValue *)valueWithHue:(NSInteger)hue saturation:(NSInteger)saturation brightness:(NSInteger)brightness alpha:(NSInteger)alpha {
    return [[CPColorValue alloc] initWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

+ (CPColorValue *)valueWithUIColor:(UIColor *)uiColor {
    return [[CPColorValue alloc] initWithUIColor:uiColor];
}

- (id)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha {
    self = [super init];
    if (self) {
        _isHSBA = NO;
        _red = MAX(0, MIN(red, CPColorValueComponentMax));
        _green = MAX(0, MIN(green, CPColorValueComponentMax));
        _blue = MAX(0, MIN(blue, CPColorValueComponentMax));
        _alpha = MAX(0, MIN(alpha, CPColorValueComponentMax));
        [self generateHSB];
    }
    return self;
}

- (id)initWithHue:(NSInteger)hue saturation:(NSInteger)saturation brightness:(NSInteger)brightness alpha:(NSInteger)alpha {
    self = [super init];
    if (self) {
        _isHSBA = YES;
        _hue = MAX(0, MIN(hue, CPColorValueComponentMax));
        _saturation = MAX(0, MIN(saturation, CPColorValueComponentMax));
        _brightness = MAX(0, MIN(brightness, CPColorValueComponentMax));
        _alpha = MAX(0, MIN(alpha, CPColorValueComponentMax));
        [self generateRBG];
    }
    return self;
}

- (id)initWithUIColor:(UIColor *)uiColor {
    self = [super init];
    if (self) {
        _isHSBA = NO;
        _uiColor = uiColor;
        [self generateRBG];
        [self generateHSB];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _isHSBA = [aDecoder decodeBoolForKey:CPColorValueEncodingKeyIsHSBA];
        if (_isHSBA) {
            _hue = [aDecoder decodeIntegerForKey:CPColorValueEncodingKeyHue];
            _saturation = [aDecoder decodeIntegerForKey:CPColorValueEncodingKeySaturation];
            _brightness = [aDecoder decodeIntegerForKey:CPColorValueEncodingKeyBrightness];
            _alpha = [aDecoder decodeIntegerForKey:CPColorValueEncodingKeyAlpha];
            [self generateRBG];
        } else {
            _red = [aDecoder decodeIntegerForKey:CPColorValueEncodingKeyRed];
            _green = [aDecoder decodeIntegerForKey:CPColorValueEncodingKeyGreen];
            _blue = [aDecoder decodeIntegerForKey:CPColorValueEncodingKeyBlue];
            _alpha = [aDecoder decodeIntegerForKey:CPColorValueEncodingKeyAlpha];
            [self generateHSB];
        }

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.isHSBA forKey:CPColorValueEncodingKeyIsHSBA];
    if (self.isHSBA) {
        [aCoder encodeInteger:self.hue forKey:CPColorValueEncodingKeyHue];
        [aCoder encodeInteger:self.saturation forKey:CPColorValueEncodingKeySaturation];
        [aCoder encodeInteger:self.brightness forKey:CPColorValueEncodingKeyBrightness];
    } else {
        [aCoder encodeInteger:self.red forKey:CPColorValueEncodingKeyRed];
        [aCoder encodeInteger:self.green forKey:CPColorValueEncodingKeyGreen];
        [aCoder encodeInteger:self.blue forKey:CPColorValueEncodingKeyBlue];
    }
    [aCoder encodeInteger:self.alpha forKey:CPColorValueEncodingKeyAlpha];
}

- (int)intValue {
    return (int)((self.red << 24) | (self.green << 16) | (self.blue << 8) | self.alpha);
}

- (double)doubleValue {
    return self.intValue;
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"RGB(%X) HSB(%06X) A(%02X)", (unsigned int)((self.red << 16) | (self.green << 8) | self.blue), (unsigned int)((self.hue << 16) | (self.saturation << 8) | self.brightness), (unsigned int)self.alpha];
}

- (BOOL)booleanValue {
    return self.red || self.green || self.blue || self.alpha;
}

- (UIColor *)uiColor {
    if (!_uiColor) {
        if (self.isHSBA) {
            _uiColor = [[UIColor alloc] initWithHue:_hue / CPColorValueComponentMax saturation:_saturation / CPColorValueComponentMax brightness:_brightness / CPColorValueComponentMax alpha:_alpha / CPColorValueComponentMax];
        } else {
            _uiColor = [[UIColor alloc] initWithRed:_red / CPColorValueComponentMax green:_green / CPColorValueComponentMax blue:_blue / CPColorValueComponentMax alpha:_alpha / CPColorValueComponentMax];
        }
    }
    return _uiColor;
}

- (unichar)headTag {
    return '#';
}

- (unichar)tailTag {
    return '#';
}

#pragma mark - private methods

- (void)generateRBG {
    CGFloat red, green, blue, alpha;
    [self.uiColor getRed:&red green:&green blue:&blue alpha:&alpha];
    _red = red * CPColorValueComponentMax;
    _green = green * CPColorValueComponentMax;
    _blue = blue * CPColorValueComponentMax;
    _alpha = alpha * CPColorValueComponentMax;
}

- (void)generateHSB {
    CGFloat hue, saturation, brightness, alpha;
    [self.uiColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    _hue = hue * CPColorValueComponentMax;
    _saturation = saturation * CPColorValueComponentMax;
    _brightness = brightness * CPColorValueComponentMax;
    _alpha = alpha * CPColorValueComponentMax;
}

@end
