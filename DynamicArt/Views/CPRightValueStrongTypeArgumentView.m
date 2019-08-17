//
//  CPRightValueStrongTypeArgumentView.m
//  Polymer
//
//  Created by wangyw on 4/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRightValueStrongTypeArgumentView.h"

#import "CPColorValue.h"
#import "CPColorInputField.h"
#import "CPImageCache.h"
#import "CPInputFieldManager.h"
#import "CPRightValueVariableInputField.h"
#import "CPRightValueStrongTypeArgument.h"

@interface CPRightValueStrongTypeArgumentView ()

- (CPRightValueStrongTypeArgument *)rightValueStrongTypeArgument;

@end

@implementation CPRightValueStrongTypeArgumentView

- (id)initWithArgument:(CPArgument *)argument {
    self = [super initWithArgument:argument];
    if (self) {
        if (self.rightValueStrongTypeArgument.value) {
            self.image = [CPImageCache rightValueArgumentBackgroundImageForValueClass:self.rightValueStrongTypeArgument.valueClass];
            if ([self.rightValueStrongTypeArgument.valueClass isSubclassOfClass:[CPColorValue class]]) {
                self.textLabel.backgroundColor = self.rightValueStrongTypeArgument.value.uiColor;
                self.textLabel.layer.borderWidth = [CPColorInputView boderWidth];
                self.textLabel.layer.cornerRadius = [CPColorInputView cornerRadius];
            } else {
                self.textLabel.text = self.rightValueStrongTypeArgument.value.stringValue;
            }
        } else {
            self.image = [CPImageCache rightValueArgumentVariableBackgroundImageForValueClass:self.rightValueStrongTypeArgument.valueClass];
            self.textLabel.text = self.rightValueStrongTypeArgument.variableName;
        }
    }
    return self;
}

- (CPRightValueStrongTypeArgument *)rightValueStrongTypeArgument {
    NSAssert([self.argument isKindOfClass:[CPRightValueStrongTypeArgument class]], @"");
    return (CPRightValueStrongTypeArgument *)self.argument;
}

- (BOOL)labelShouldBeginEditing:(CPLabel *)label {
    self.textLabel.hidden = YES;
    
    Class inputFieldClass;
    if (self.rightValueStrongTypeArgument.value) {
        inputFieldClass = [[CPInputFieldManager defaultInputFieldManager] inputFieldClassOfValueClass:self.rightValueStrongTypeArgument.valueClass];
    } else {
        inputFieldClass = [CPRightValueVariableInputField class];
    }
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:inputFieldClass forArgumentView:self];
    
    return YES;
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    if (self.rightValueStrongTypeArgument.value) {
        if ([self.rightValueStrongTypeArgument.valueClass isSubclassOfClass:[CPColorValue class]]) {
            self.textLabel.text = @"";
            self.textLabel.backgroundColor = self.rightValueStrongTypeArgument.value.uiColor;
            self.textLabel.layer.borderWidth = [CPColorInputView boderWidth];
            self.textLabel.layer.cornerRadius = [CPColorInputView cornerRadius];
        } else {
            self.textLabel.text = self.rightValueStrongTypeArgument.value.stringValue;
            self.textLabel.backgroundColor = [UIColor clearColor];
            self.textLabel.layer.borderWidth = 0.0;
            self.textLabel.layer.cornerRadius = 0.0;
        }
    } else {
        self.textLabel.text = self.rightValueStrongTypeArgument.variableName;
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
            self.image = [CPImageCache rightValueArgumentBackgroundImageForValueClass:self.rightValueStrongTypeArgument.valueClass];
            inputFieldClass = [[CPInputFieldManager defaultInputFieldManager] inputFieldClassOfValueClass:self.rightValueStrongTypeArgument.valueClass];
            break;
        case 1:
            self.image = [CPImageCache rightValueArgumentVariableBackgroundImageForValueClass:self.rightValueStrongTypeArgument.valueClass];
            inputFieldClass = [CPRightValueVariableInputField class];
            break;
        default:
            NSAssert(NO, @"");
            break;
    }
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:inputFieldClass forArgumentView:self];
}

@end
