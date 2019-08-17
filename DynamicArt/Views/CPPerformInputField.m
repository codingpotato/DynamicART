//
//  CPPerformInputField.m
//  DynamicArt
//
//  Created by wangyw on 10/24/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPerformInputField.h"

#import "CPInputFieldManager.h"

#import "CPBlockConfiguration.h"
#import "CPMyStartupManager.h"
#import "CPPerformArgument.h"

@interface CPPerformInputField ()

@property (strong, nonatomic) NSArray *myStartupNames;

- (CPPerformArgument *)performArgument;

@end

@implementation CPPerformInputField

#pragma mark - property methods

- (NSArray *)myStartupNames {
    if (!_myStartupNames) {
        _myStartupNames = [[NSArray alloc] init];
    }
    return _myStartupNames;
}

- (CPPerformArgument *)performArgument {
    return (CPPerformArgument *)self.argument;
}

#pragma mark -

- (id)init {
    self = [super init];
    if (self) {
        self.textField.inputView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    }
    return self;
}

- (void)willShow {
    self.textField.font = self.argument.blockConfiguration.argumentFont;
    self.textField.text = self.performArgument.startupName;
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

#pragma mark - UITextFieldDelegate implement

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.myStartupNames = self.argument.myStartupManager.myStartupNames;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.performArgument updateStartupName:self.textField.text];
}

@end
