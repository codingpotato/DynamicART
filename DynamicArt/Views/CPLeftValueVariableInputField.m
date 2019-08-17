//
//  CPLeftValueVariableInputField.m
//  DynamicArt
//
//  Created by wangyw on 10/31/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLeftValueVariableInputField.h"

#import "CPBlockConfiguration.h"
#import "CPInputFieldManager.h"
#import "CPLeftValueArgument.h"
#import "CPPopoverManager.h"
#import "CPVariableManager.h"

@interface CPLeftValueVariableInputField ()

@property (strong, nonatomic) NSArray *variableNames;

- (CPLeftValueArgument *)leftValueArgument;

@end

@implementation CPLeftValueVariableInputField

- (void)willShow {
    self.textField.font = self.argument.blockConfiguration.argumentFont;
    self.textField.text = self.leftValueArgument.variableName;
}

- (CPLeftValueArgument *)leftValueArgument {
    return (CPLeftValueArgument *)self.argument;
}

- (CGSize)contentSizeOfAutoCompleteView {
    return CGSizeMake(300.0, 500.0);
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)self.variableNames.count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    NSAssert(index >= 0 && index < self.variableNames.count, @"");
    
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
    
    self.variableNames = [self filterArray:self.argument.variableManager.allUserValueVariableNames withPrefix:self.textField.text];
    [[CPPopoverManager defaultPopoverManager] reloadDataOfAutoCompleteViewController];
}

#pragma mark - UITextFieldDelegate implement

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.variableNames = self.argument.variableManager.allUserValueVariableNames;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.textField.text || [self.textField.text isEqualToString:@""]) {
        self.textField.text = self.leftValueArgument.variableManager.lastUsedUserValueVariableName;
    }
    [self.leftValueArgument updateVariableName:self.textField.text];
}

@end
