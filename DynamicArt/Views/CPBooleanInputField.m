//
//  CPBooleanInputField.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBooleanInputField.h"

#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPInputFieldManager.h"
#import "CPRightValueWeakTypeArgument.h"

@interface CPBooleanInputField ()

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument;

@end

@implementation CPBooleanInputField

- (id)init {
    self = [super init];
    if (self) {
        self.textField.inputView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    }
    return self;
}

- (void)willShow {
    if (!self.rightValueWeakTypeArgument.value || ![self.rightValueWeakTypeArgument.value isKindOfClass:[CPBooleanValue class]]) {
        BOOL booleanValue = [self.textField.text isEqualToString:[CPBooleanValue trueValue].stringValue];
        [self.rightValueWeakTypeArgument updateValue:[CPBooleanValue valueWithBoolean:booleanValue]];
    }
    self.textField.font = self.argument.blockConfiguration.argumentFont;
    self.textField.text = self.rightValueWeakTypeArgument.value.stringValue;
}

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument {
    NSAssert([self.argument isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");
    return (CPRightValueWeakTypeArgument *)self.argument;
}

- (CGSize)contentSizeOfAutoCompleteView {
    return CGSizeMake(100.0, 90.0);
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)[CPBooleanValue booleanConstants].count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    cell.textLabel.text = [[CPBooleanValue booleanConstants] objectAtIndex:index];
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    NSAssert(index >= 0 && index < [CPBooleanValue booleanConstants].count, @"");
        
    self.textField.text = [[CPBooleanValue booleanConstants] objectAtIndex:index];
    BOOL booleanValue = [self.textField.text isEqualToString:[CPBooleanValue trueValue].stringValue];
    [self.rightValueWeakTypeArgument updateValue:(booleanValue ? [CPBooleanValue trueValue] : [CPBooleanValue falseValue])];
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

#pragma mark - UITextFieldDelegate implement

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

@end
