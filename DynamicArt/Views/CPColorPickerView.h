//
//  CPColorPickerView.h
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPColorPickerView;
@class CPColorValue;
@class CPGradientView;

@protocol CPColorPickerViewDelegate <NSObject>

- (void)colorChangedByColorPickView:(CPColorPickerView *)colorPickerView;

@end

@interface CPColorPickerView : UIView

@property (nonatomic) NSUInteger currentHue;

@property (nonatomic) NSUInteger currentSaturation;

@property (nonatomic) NSUInteger currentBrightness;

@property (nonatomic) NSUInteger currentAlpha;

@property (weak, nonatomic) IBOutlet id<CPColorPickerViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *colorMapImageView;

@property (weak, nonatomic) IBOutlet UIImageView *crossHairs;

@property (weak, nonatomic) IBOutlet UILabel *hueLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturationLabel;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (weak, nonatomic) IBOutlet UIStepper *hueStepper;
@property (weak, nonatomic) IBOutlet UIStepper *saturationStepper;
@property (weak, nonatomic) IBOutlet UIStepper *brightnessStepper;

@property (weak, nonatomic) IBOutlet CPGradientView *brightnessGradientView;

@property (weak, nonatomic) IBOutlet UIImageView *brightnessBar;

@property (weak, nonatomic) IBOutlet CPGradientView *alphaGradientView;

@property (weak, nonatomic) IBOutlet UIImageView *alphaBar;

@property (weak, nonatomic) IBOutlet UILabel *alphaLabel;
@property (weak, nonatomic) IBOutlet UIStepper *alphaStepper;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (void)didFinishLoad;

- (void)setHue:(NSUInteger)hue saturation:(NSUInteger)saturation brightness:(NSUInteger)brightness alpha:(NSUInteger)alpha;

- (IBAction)stepperValueChanged:(UIStepper *)sender;

@end
