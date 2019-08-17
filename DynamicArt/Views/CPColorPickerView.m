//
//  CPColorPickerView.m
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPColorPickerView.h"

#import "CPColorValue.h"
#import "CPGradientView.h"
#import "CPImageCache.h"

typedef enum {
    CPColorPickerViewTouchTypeNone,
    CPColorPickerViewTouchTypeColorMap,
    CPColorPickerViewTouchTypeBrightness,
    CPColorPickerViewTouchTypeAlpha
} CPColorPickerViewTouchType;

@interface CPColorPickerView ()

@property (nonatomic) CPColorPickerViewTouchType touchType;

- (void)updateHueSaturationWithMovement:(CGPoint)position;

- (void)updateBrightnessWithMovement:(CGPoint)position;

- (void)updateAlphaWithMovement:(CGPoint)position;

- (void)dispatchTouchEvent:(CGPoint)position;

@end

@implementation CPColorPickerView

- (void)didFinishLoad {
    self.colorMapImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.colorMapImageView.layer.borderWidth = 1.0;
    self.colorMapImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.colorMapImageView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.colorMapImageView.layer.shadowOpacity = 0.8;

    self.brightnessGradientView.type = CPGradientViewTypeBrightness;
    self.alphaGradientView.type = CPGradientViewTypeAlpha;
    self.alphaGradientView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alpha_bg.png"]];
    
    [self.doneButton setBackgroundImage:[CPImageCache keyBackgoundImage] forState:UIControlStateNormal];
}

- (void)setHue:(NSUInteger)hue saturation:(NSUInteger)saturation brightness:(NSUInteger)brightness alpha:(NSUInteger)alpha{
    self.currentHue = hue;
    self.currentSaturation = saturation;
    self.currentBrightness = brightness;
    self.currentAlpha = alpha;
    
    CGRect colorMapRect = self.colorMapImageView.frame;
    CGPoint hueSaturationPosition;
    hueSaturationPosition.x = (self.currentHue / CPColorValueComponentMax * (colorMapRect.size.width - 1.0)) + colorMapRect.origin.x;
    hueSaturationPosition.y = (1.0 - self.currentSaturation / CPColorValueComponentMax) * (colorMapRect.size.height - 1.0) + colorMapRect.origin.y;
    self.crossHairs.center = hueSaturationPosition;
    
    self.hueLabel.text = [[NSString alloc] initWithFormat:@"%d", (unsigned int)self.currentHue];
    self.saturationLabel.text = [[NSString alloc] initWithFormat:@"%d", (unsigned int)self.currentSaturation];
    self.brightnessLabel.text = [[NSString alloc] initWithFormat:@"%d", (unsigned int)self.currentBrightness];
    self.hueStepper.value = self.hueLabel.text.intValue;
    self.saturationStepper.value = self.saturationLabel.text.intValue;
    self.brightnessStepper.value = self.brightnessLabel.text.intValue;
    
    [self.brightnessGradientView setHue:self.currentHue saturation:self.currentSaturation brightness:self.self.currentBrightness alpha:self.currentAlpha];
    
    CGRect brightnessGradientViewRect = self.brightnessGradientView.frame;
    CGPoint brightnessPosition;
    brightnessPosition.x = self.currentBrightness / CPColorValueComponentMax * (brightnessGradientViewRect.size.width - 1.0) + brightnessGradientViewRect.origin.x;
    brightnessPosition.y = brightnessGradientViewRect.origin.y + brightnessGradientViewRect.size.height / 2;
    self.brightnessBar.center = brightnessPosition;
    
    [self.alphaGradientView setHue:self.currentHue saturation:self.currentSaturation brightness:self.currentBrightness alpha:self.currentAlpha];
    
    CGRect alphaGradientViewRect = self.alphaGradientView.frame;
    CGPoint alphaPosition;
    alphaPosition.x = self.currentAlpha / CPColorValueComponentMax * (alphaGradientViewRect.size.width - 1.0) + alphaGradientViewRect.origin.x;
    alphaPosition.y = alphaGradientViewRect.origin.y + alphaGradientViewRect.size.height / 2;
    self.alphaBar.center = alphaPosition;
    
    self.alphaLabel.text = [[NSString alloc] initWithFormat:@"%d", (unsigned int)self.currentAlpha];
    self.alphaStepper.value = self.alphaLabel.text.intValue;
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    switch (sender.tag) {
        case 0:
            // hue
            [self setHue:sender.value saturation:self.currentSaturation brightness:self.currentBrightness alpha:self.currentAlpha];
            break;
        case 1:
            // saturation
            [self setHue:self.currentHue saturation:sender.value brightness:self.currentBrightness alpha:self.currentAlpha];
            break;
        case 2:
            // brightness
            [self setHue:self.currentHue saturation:self.currentSaturation brightness:sender.value alpha:self.currentAlpha];
            break;
        case 3:
            // alpha
            [self setHue:self.currentHue saturation:self.currentSaturation brightness:self.currentBrightness alpha:sender.value];
            break;
        default:
            NSAssert(NO, @"");
            break;
    }
    [self.delegate colorChangedByColorPickView:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint position = [touches.anyObject locationInView:self.colorMapImageView];
    if (CGRectContainsPoint(self.colorMapImageView.bounds, position)) {
        self.touchType = CPColorPickerViewTouchTypeColorMap;
    } else {
        position = [touches.anyObject locationInView:self.brightnessGradientView];
        if (CGRectContainsPoint(self.brightnessGradientView.bounds, position)) {
            self.touchType = CPColorPickerViewTouchTypeBrightness;
        } else {
            position = [touches.anyObject locationInView:self.alphaGradientView];
            if (CGRectContainsPoint(self.alphaGradientView.bounds, position)) {
                self.touchType = CPColorPickerViewTouchTypeAlpha;
            } else {
                self.touchType = CPColorPickerViewTouchTypeNone;
            }
        }
    }
    [self dispatchTouchEvent:[touches.anyObject locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dispatchTouchEvent:[touches.anyObject locationInView:self]];
}

#pragma mark - private methods

- (void)updateHueSaturationWithMovement:(CGPoint)position {
	CGFloat hue = position.x / (self.colorMapImageView.bounds.size.width - 1.0) * CPColorValueComponentMax;
	CGFloat saturation = (1.0 -  position.y / (self.colorMapImageView.bounds.size.height - 1.0)) * CPColorValueComponentMax;
    [self setHue:hue saturation:saturation brightness:self.currentBrightness alpha:self.currentAlpha];

    [self.delegate colorChangedByColorPickView:self];
}


- (void)updateBrightnessWithMovement:(CGPoint)position {
    CGFloat brightness = position.x / (self.brightnessGradientView.bounds.size.width - 1.0) * CPColorValueComponentMax;
    [self setHue:self.currentHue saturation:self.currentSaturation brightness:brightness alpha:self.currentAlpha];
    
    [self.delegate colorChangedByColorPickView:self];
}

- (void)updateAlphaWithMovement:(CGPoint)position {
    CGFloat alpha = position.x / (self.alphaGradientView.bounds.size.width - 1.0) * CPColorValueComponentMax;
    [self setHue:self.currentHue saturation:self.currentSaturation brightness:self.currentBrightness alpha:alpha];
    
    [self.delegate colorChangedByColorPickView:self];
}

- (void)dispatchTouchEvent:(CGPoint)position {
    UIView *touchView = nil;
    switch (self.touchType) {
        case CPColorPickerViewTouchTypeColorMap:
            touchView = self.colorMapImageView;
            break;
        case CPColorPickerViewTouchTypeBrightness:
            touchView = self.brightnessGradientView;
            break;
        case CPColorPickerViewTouchTypeAlpha:
            touchView = self.alphaGradientView;
            break;
        default:
            break;
    }

    if (touchView) {
        position = [self convertPoint:position toView:touchView];
        position.x = fmax(position.x, 0.0);
        position.x = fmin(position.x, touchView.bounds.size.width - 1);
        position.y = fmax(position.y, 0.0);
        position.y = fmin(position.y, touchView.bounds.size.height - 1);
        
        switch (self.touchType) {
            case CPColorPickerViewTouchTypeColorMap:
                [self updateHueSaturationWithMovement:position];
                break;
            case CPColorPickerViewTouchTypeBrightness:
                [self updateBrightnessWithMovement:position];
                break;
            case CPColorPickerViewTouchTypeAlpha:
                [self updateAlphaWithMovement:position];
                break;
            default:
                NSAssert(NO, @"");
                break;
        }
    }
}

@end
