//
//  CPArrayInputField.m
//  DynamicArt
//
//  Created by wangyw on 10/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArrayInputField.h"

#import "CPArrayArgument.h"
#import "CPBlockConfiguration.h"
#import "CPInputFieldManager.h"
#import "CPPopoverManager.h"
#import "CPVariableManager.h"

@interface CPArrayInputField ()

@property (strong, nonatomic) NSArray *arrayNames;

- (CPArrayArgument *)arrayArgument;

@end

@implementation CPArrayInputField

- (void)willShow {
    self.textField.font = self.argument.blockConfiguration.argumentFont;
    self.textField.text = self.arrayArgument.arrayName;
}

- (CPArrayArgument *)arrayArgument {
    return (CPArrayArgument *)self.argument;
}

- (CGSize)contentSizeOfAutoCompleteView {
    return CGSizeMake(300.0, 500.0);
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)self.arrayNames.count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    NSAssert(index >= 0 && index < self.arrayNames.count, @"");
    
    NSString *variableName = [self.arrayNames objectAtIndex:index];
    cell.textLabel.text = variableName;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"used count: %d", (int)[self.argument.variableManager retainCountForArrayVariable:variableName]];
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    NSAssert(index >= 0 && index < self.arrayNames.count, @"");

    self.textField.text = [self.arrayNames objectAtIndex:index];
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

- (void)textFieldDidChanged:(id)sender {
    [super textFieldDidChanged:sender];

    self.arrayNames = [self filterArray:self.argument.variableManager.allArrayVariableNames withPrefix:self.textField.text];
    [[CPPopoverManager defaultPopoverManager] reloadDataOfAutoCompleteViewController];
}

#pragma mark - UITextFieldDelegate implement

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.arrayNames = self.argument.variableManager.allArrayVariableNames;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.textField.text || [self.textField.text isEqualToString:@""]) {
        self.textField.text = self.arrayArgument.variableManager.lastUsedUserArrayVariableName;
    }
    [self.arrayArgument updateArrayName:self.textField.text];
}

@end
