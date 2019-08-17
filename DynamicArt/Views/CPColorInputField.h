//
//  CPColorInputField.h
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"
#import "CPColorPickerView.h"
#import "CPInputField.h"

@class CPColorValue;

@interface CPColorInputView : UIView

@property (strong, nonatomic) CPColorValue *colorValue;

@property (strong, nonatomic) UIView *inputView;

@property (strong, nonatomic) UIView *inputAccessoryView;

+ (CGFloat)boderWidth;

+ (CGFloat)cornerRadius;

@end

@interface CPColorInputField : CPInputField <CPCacheItem, CPColorPickerViewDelegate>

@property (strong, nonatomic) CPColorInputView *colorInputView;

- (IBAction)inputViewReturned:(id)sender;

@end
