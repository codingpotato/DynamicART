//
//  CPRightValueVariableInputField.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRightValueVariableInputField.h"

#import "CPBlockConfiguration.h"
#import "CPInputFieldManager.h"
#import "CPPopoverManager.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPVariableManager.h"

@interface CPRightValueVariableInputField ()

@property (strong, nonatomic) NSArray *variableNames;

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument;

@end

@implementation CPRightValueVariableInputField

- (void)willShow {
    self.textField.font = self.argument.blockConfiguration.argumentFont;
    if (self.rightValueWeakTypeArgument.variableName) {
        self.textField.text = self.rightValueWeakTypeArgument.variableName;
    } else {
        self.textField.text = self.rightValueWeakTypeArgument.variableManager.lastUsedUserValueVariableName;
        [self.rightValueWeakTypeArgument updateVariableName:self.textField.text];
    }
}

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument {
    return (CPRightValueWeakTypeArgument *)self.argument;
}

- (CGSize)contentSizeOfAutoCompleteView {
    return CGSizeMake(300.0, 500.0);
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)self.variableNames.count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    NSString *variableName = [self.variableNames objectAtIndex:index];
    cell.textLabel.text = variableName;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"used count: %d", (unsigned int)[self.argument.variableManager retainCountForValueVariable:variableName]];
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    NSAssert(index >= 0 && index < self.variableNames.count, @"");
    
    self.textField.text = [self.variableNames objectAtIndex:index];
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

- (void)textFieldDidChanged:(id)sender {
    [super textFieldDidChanged:sender];
    
    self.variableNames = [self filterArray:self.argument.variableManager.allValueVariableNames withPrefix:self.textField.text];
    [[CPPopoverManager defaultPopoverManager] reloadDataOfAutoCompleteViewController];
}

#pragma mark - UITextFieldDelegate implement

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.variableNames = self.argument.variableManager.allValueVariableNames;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.textField.text || [self.textField.text isEqualToString:@""]) {
        self.textField.text = self.rightValueWeakTypeArgument.variableManager.lastUsedUserValueVariableName;
    }
    [self.rightValueWeakTypeArgument updateVariableName:self.textField.text];
}

@end
