//
//  CPRightValueWeakTypeArgumentView.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRightValueWeakTypeArgumentView.h"

#import "CPImageCache.h"
#import "CPInputFieldManager.h"
#import "CPBooleanInputField.h"
#import "CPBooleanValue.h"
#import "CPColorInputField.h"
#import "CPColorValue.h"
#import "CPNumberInputField.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPRightValueVariableInputField.h"
#import "CPStringInputField.h"
#import "CPStringValue.h"

@interface CPRightValueWeakTypeArgumentView ()

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument;

@end

@implementation CPRightValueWeakTypeArgumentView

#pragma mark -

- (id)initWithArgument:(CPArgument *)argument {
    self = [super initWithArgument:argument];
    if (self) {
        if (self.rightValueWeakTypeArgument.value) {
            self.image = [CPImageCache rightValueArgumentBackgroundImageForValueClass:self.rightValueWeakTypeArgument.value.class];
            if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPBooleanValue class]]) {
                self.textLabel.text = self.rightValueWeakTypeArgument.value.stringValue;
            } else if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPColorValue class]]) {
                self.textLabel.backgroundColor = self.rightValueWeakTypeArgument.value.uiColor;
                self.textLabel.layer.borderWidth = [CPColorInputView boderWidth];
                self.textLabel.layer.cornerRadius = [CPColorInputView cornerRadius];
            } else if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPNumberValue class]]) {
                self.textLabel.text = self.rightValueWeakTypeArgument.value.stringValue;
            } else if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPStringValue class]]) {
                self.textLabel.text = self.rightValueWeakTypeArgument.value.stringValue;
            }
        } else {
            self.image = [CPImageCache variableArgumentBackgroundImage];
            self.textLabel.text = self.rightValueWeakTypeArgument.variableName;
        }
    }
    return self;
}

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument {
    NSAssert([self.argument isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");
    return (CPRightValueWeakTypeArgument *)self.argument;
}

- (BOOL)labelShouldBeginEditing:(CPLabel *)label {
    self.textLabel.hidden = YES;
    
    Class inputFieldClass;
    if (self.rightValueWeakTypeArgument.value) {
        if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPBooleanValue class]]) {
            inputFieldClass = [CPBooleanInputField class];
        } else if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPColorValue class]]) {
            inputFieldClass = [CPColorInputField class];
        } else if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPNumberValue class]]) {
            inputFieldClass = [CPNumberInputField class];
        } else if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPStringValue class]]) {
            inputFieldClass = [CPStringInputField class];
        }
    } else {
        inputFieldClass = [CPRightValueVariableInputField class];
    }
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:inputFieldClass forArgumentView:self];
    
    return YES;
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    if (self.rightValueWeakTypeArgument.value) {
        if ([self.rightValueWeakTypeArgument.value isKindOfClass:[CPColorValue class]]) {
            self.textLabel.text = @"";
            self.textLabel.backgroundColor = self.rightValueWeakTypeArgument.value.uiColor;
            self.textLabel.layer.borderWidth = [CPColorInputView boderWidth];
            self.textLabel.layer.cornerRadius = [CPColorInputView cornerRadius];
        } else {
            self.textLabel.text = self.rightValueWeakTypeArgument.value.stringValue;
            self.textLabel.backgroundColor = [UIColor clearColor];
            self.textLabel.layer.borderWidth = 0.0;
            self.textLabel.layer.cornerRadius = 0.0;
        }
    } else {
        self.textLabel.text = self.rightValueWeakTypeArgument.variableName;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.layer.borderWidth = 0.0;
        self.textLabel.layer.cornerRadius = 0.0;
    }
    self.textLabel.hidden = NO;
}

- (void)inputTypeChangedTo:(int)index {
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
    self.textLabel.hidden = YES;

    Class inputFieldClass;
    switch (index) {
        case 0:
            self.image = [CPImageCache rightValueArgumentBackgroundImageForValueClass:[CPBooleanValue class]];
            inputFieldClass = [CPBooleanInputField class];
            break;
        case 1:
            self.image = [CPImageCache rightValueArgumentBackgroundImageForValueClass:[CPColorValue class]];
            inputFieldClass = [CPColorInputField class];
            break;
        case 2:
            self.image = [CPImageCache rightValueArgumentBackgroundImageForValueClass:[CPNumberValue class]];
            inputFieldClass = [CPNumberInputField class];
            break;
        case 3:
            self.image = [CPImageCache rightValueArgumentBackgroundImageForValueClass:[CPStringValue class]];
            inputFieldClass = [CPStringInputField class];
            break;
        case 4:
            self.image = [CPImageCache variableArgumentBackgroundImage];
            inputFieldClass = [CPRightValueVariableInputField class];
            break;
        default:
            NSAssert(NO, @"");
            break;
    }
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:inputFieldClass forArgumentView:self];
}

@end
