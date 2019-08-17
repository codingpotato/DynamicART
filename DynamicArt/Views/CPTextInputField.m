//
//  CPTextInputField.m
//  DynamicArt
//
//  Created by wangyw on 11/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTextInputField.h"

#import "CPArgument.h"
#import "CPInputFieldManager.h"
#import "CPPopoverManager.h"

@implementation CPTextInputField

- (UIView *)view {
    return self.textField;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)textFieldDidChanged:(id)sender {
    [self.argument resizeForString:self.textField.text byNotifyParentBlock:YES];
}

#pragma mark - UITextFieldDelegate implement

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
    return YES;
}

@end
