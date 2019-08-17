//
//  CPMyStartupInputField.m
//  DynamicArt
//
//  Created by wangyw on 10/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMyStartupInputField.h"

#import "CPBlockConfiguration.h"
#import "CPInputFieldManager.h"
#import "CPMyStartupArgument.h"
#import "CPMyStartupManager.h"
#import "CPPerformArgument.h"
#import "CPPopoverManager.h"

@interface CPMyStartupInputField ()

@property (strong, nonatomic) NSArray *myStartupNames;

- (CPMyStartupArgument *)myStartupArgument;

@end

@implementation CPMyStartupInputField

- (NSArray *)myStartupNames {
    if (!_myStartupNames) {
        _myStartupNames = [[NSArray alloc] init];
    }
    return _myStartupNames;
}

- (CPMyStartupArgument *)myStartupArgument {
    return (CPMyStartupArgument *)self.argument;
}

- (void)willShow {
    self.textField.font = self.argument.blockConfiguration.argumentFont;
    self.textField.text = self.myStartupArgument.startupName;
}

- (CGSize)contentSizeOfAutoCompleteView {
    return CGSizeMake(300.0, 500.0);
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)self.myStartupNames.count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    NSAssert(index >= 0 && index < self.myStartupNames.count, @"");
    
    NSString *variableName = [self.myStartupNames objectAtIndex:index];
    cell.textLabel.text = variableName;
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    NSAssert(index >= 0 && index < self.myStartupNames.count, @"");
    
    self.textField.text = [self.myStartupNames objectAtIndex:index];
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

- (void)textFieldDidChanged:(id)sender {
    [super textFieldDidChanged:sender];
    
    self.myStartupNames = [self filterArray:self.argument.myStartupManager.myStartupNames withPrefix:self.textField.text];
    [[CPPopoverManager defaultPopoverManager] reloadDataOfAutoCompleteViewController];
}

#pragma mark - UITextFieldDelegate implement

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.myStartupNames = self.argument.myStartupManager.myStartupNames;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.myStartupArgument updateStartupName:self.textField.text];
}

@end
