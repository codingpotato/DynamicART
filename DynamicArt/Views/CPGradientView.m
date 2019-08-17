//
//  CPGradientView.m
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPGradientView.h"

#import "CPColorValue.h"

@interface CPGradientView ()

@property (nonatomic) NSUInteger currentHue;

@property (nonatomic) NSUInteger currentSaturation;

@property (nonatomic) NSUInteger currentBrightness;

@end

@implementation CPGradientView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        self.layer.shadowOpacity = 0.8;
    }
    return self;
}

- (void)setHue:(NSUInteger)hue saturation:(NSUInteger)saturation brightness:(NSUInteger)brightness alpha:(NSUInteger)alpha {
    self.currentHue = hue;
    self.currentSaturation = saturation;
    self.currentBrightness = brightness;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat floatHue = self.currentHue / CPColorValueComponentMax;
    CGFloat floatSaturation = self.currentSaturation / CPColorValueComponentMax;
    CGFloat floatBrightness = self.currentBrightness / CPColorValueComponentMax;

    CGFloat colors[8];
    const CGFloat *colorComponents = nil;
    switch (self.type) {
        case CPGradientViewTypeBrightness:
            colorComponents = CGColorGetComponents([[UIColor colorWithHue:floatHue saturation:floatSaturation brightness:0.0 alpha:1.0] CGColor]);
            colors[3] = 1.0;
            break;
        case CPGradientViewTypeAlpha:
            colorComponents = CGColorGetComponents([[UIColor colorWithHue:floatHue saturation:floatSaturation brightness:floatBrightness alpha:0.0] CGColor]);
            colors[3] = 0.0;
            break;
    }
    colors[0] = colorComponents[0];
    colors[1] = colorComponents[1];
    colors[2] = colorComponents[2];
    switch (self.type) {
        case CPGradientViewTypeBrightness:
            colorComponents = CGColorGetComponents([[UIColor colorWithHue:floatHue saturation:floatSaturation brightness:1.0 alpha:1.0] CGColor]);
            break;
        case CPGradientViewTypeAlpha:
            colorComponents = CGColorGetComponents([[UIColor colorWithHue:floatHue saturation:floatSaturation brightness:floatBrightness alpha:1.0] CGColor]);
            break;
    }
    colors[4] = colorComponents[0];
    colors[5] = colorComponents[1];
    colors[6] = colorComponents[2];
    colors[7] = 1.0;
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    
    CGContextDrawLinearGradient(context, gradient, self.bounds.origin, CGPointMake(self.bounds.size.width - 1.0, 0.0), 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
