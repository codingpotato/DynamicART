//
//  CPTextInputField.h
//  DynamicArt
//
//  Created by wangyw on 11/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPInputField.h"

@interface CPTextInputField : CPInputField <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;

- (void)textFieldDidChanged:(id)sender;

@end
