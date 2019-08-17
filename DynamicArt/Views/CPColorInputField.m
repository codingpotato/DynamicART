//
//  CPColorInputField.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPColorInputField.h"

#import "CPColorPickerView.h"
#import "CPColorValue.h"
#import "CPInputFieldManager.h"
#import "CPPopoverManager.h"
#import "CPRightValueWeakTypeArgument.h"

@implementation CPColorInputView

@synthesize colorValue = _colorValue;

+ (CGFloat)boderWidth {
    return 1.0;
}

+ (CGFloat)cornerRadius {
    return 5.0;
}

- (CPColorValue *)colorValue {
    if (!_colorValue) {
        _colorValue = [CPColorValue valueWithRed:CPColorValueComponentMax green:CPColorValueComponentMax blue:CPColorValueComponentMax alpha:CPColorValueComponentMax];
    }
    return _colorValue;
}

- (void)setColorValue:(CPColorValue *)colorValue {
    _colorValue = colorValue;
    self.backgroundColor = _colorValue.uiColor;
}

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.layer.borderWidth = [CPColorInputView boderWidth];
        self.layer.cornerRadius = [CPColorInputView cornerRadius];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end

@interface CPColorInputField ()

@property (strong, nonatomic) IBOutlet CPColorPickerView *colorPickerView;

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument;

- (NSMutableArray *)colorCache;

- (void)cacheColorValue:(CPColorValue *)colorValue;

@end

@implementation CPColorInputField

- (UIView *)view {
    return self.colorInputView;
}

- (CPColorInputView *)colorInputView {
    if (!_colorInputView) {
        _colorInputView = [[CPColorInputView alloc] init];
        _colorInputView.inputView = self.colorPickerView;
    }
    return _colorInputView;
}

- (CPColorPickerView *)colorPickerView {
    if (!_colorPickerView) {
        [[NSBundle mainBundle] loadNibNamed:@"CPColorKeyboardView" owner:self options:nil];
        _colorPickerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"color_keyboard_bg.png"]];
        [_colorPickerView didFinishLoad];
        _colorPickerView.delegate = self;
    }
    return _colorPickerView;
}

- (void)willShow {
    if (!self.rightValueWeakTypeArgument.value || ![self.rightValueWeakTypeArgument.value isKindOfClass:[CPColorValue class]]) {
        [self.rightValueWeakTypeArgument updateValue:self.colorInputView.colorValue];
    }
    CPColorValue *colorValue = self.rightValueWeakTypeArgument.value;
    self.colorInputView.colorValue = colorValue;
    [self.colorPickerView setHue:colorValue.hue saturation:colorValue.saturation brightness:colorValue.brightness alpha:colorValue.alpha];
    [self cacheColorValue:colorValue];
}

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument {
    NSAssert([self.argument isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");
    return (CPRightValueWeakTypeArgument *)self.argument;
}

- (IBAction)inputViewReturned:(id)sender {
    [self cacheColorValue:self.colorInputView.colorValue];
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

- (CGSize)contentSizeOfAutoCompleteView {
    return CGSizeMake(50.0, 500.0);
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)self.colorCache.count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    CPColorValue *colorValue = [self.colorCache objectAtIndex:index];
    NSAssert(colorValue, @"");
    
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.contentView.backgroundColor = colorValue.uiColor;
    cell.contentView.layer.cornerRadius = 45.0;
    cell.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.contentView.layer.shadowOffset = CGSizeZero;
    cell.contentView.layer.shadowOpacity = 1.0;
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    NSAssert(index >= 0 && index < self.colorCache.count, @"");

    self.colorInputView.colorValue = [self.colorCache objectAtIndex:index];
    [self.rightValueWeakTypeArgument updateValue:self.colorInputView.colorValue];
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

#pragma mark - CPCacheItem implement

static NSMutableArray *_colorCache;

+ (void)releaseCache {
    _colorCache = nil;
}

- (NSMutableArray *)colorCache {
    if (!_colorCache) {
        _colorCache = [NSMutableArray arrayWithCapacity:10];
        [CPCacheManager addCachedClass:self.class];
    }
    return _colorCache;
}

- (void)cacheColorValue:(CPColorValue *)colorValue {
    if (colorValue) {
        BOOL found = NO;
        for (CPColorValue *cachedColor in self.colorCache) {
            if ([cachedColor.uiColor isEqual:colorValue.uiColor]) {
                found = YES;
                break;
            }
        }
        if (!found) {
            while (self.colorCache.count >= 10) {
                [self.colorCache removeObjectAtIndex:self.colorCache.count - 1];
            }
            [self.colorCache insertObject:colorValue atIndex:0];
        }
    }
}

#pragma mark - CPColorPickerViewDelegate implement

- (void)colorChangedByColorPickView:(CPColorPickerView *)colorPickerView {
    self.colorInputView.colorValue = [CPColorValue valueWithHue:colorPickerView.currentHue saturation:colorPickerView.currentSaturation brightness:colorPickerView.currentBrightness alpha:colorPickerView.currentAlpha];
    [self.rightValueWeakTypeArgument updateValue:self.colorInputView.colorValue];
}

@end
