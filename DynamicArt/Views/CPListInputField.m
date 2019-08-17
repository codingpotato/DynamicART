//
//  CPListInputField.m
//  DynamicArt
//
//  Created by wangyw on 5/6/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPListInputField.h"

#import "CPBlockConfiguration.h"
#import "CPFontArgument.h"
#import "CPInputFieldManager.h"
#import "CPLineJoinArgument.h"
#import "CPListArgument.h"
#import "CPMathFunctionArgument.h"
#import "CPVariableTypeArgument.h"

@interface CPListInputField ()

- (CPListArgument *)listArgument;

@end

@implementation CPListInputField

- (id)init {
    self = [super init];
    if (self) {
        self.textField.inputView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    }
    return self;
}

- (void)willShow {
    self.textField.text = self.listArgument.currentText;
    if ([self.listArgument isKindOfClass:[CPFontArgument class]]) {
        self.textField.font = [UIFont fontWithName:self.textField.text size:self.argument.blockConfiguration.argumentFont.pointSize];
    } else {
        self.textField.font = self.argument.blockConfiguration.argumentFont;
    }
}

- (CPListArgument *)listArgument {
    NSAssert([self.argument isKindOfClass:[CPListArgument class]], @"");
    return (CPListArgument *)self.argument;
}

- (CGSize)contentSizeOfAutoCompleteView {
    if ([self.listArgument isKindOfClass:[CPFontArgument class]]) {
        return CGSizeMake(300.0, 500.0);
    } else if ([self.listArgument isKindOfClass:[CPLineJoinArgument class]]) {
        return CGSizeMake(100.0, 135.0);
    } else if ([self.listArgument isKindOfClass:[CPVariableTypeArgument class]]) {
        return CGSizeMake(100.0, 180.0);
    } else if ([self.listArgument isKindOfClass:[CPMathFunctionArgument class]]) {
        return CGSizeMake(100.0, 580.0);
    } else {
        return CGSizeZero;
    }
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)self.listArgument.listArray.count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    NSString *string = [self.listArgument.listArray objectAtIndex:index];
    if ([self.argument isKindOfClass:[CPFontArgument class]]) {
        cell.textLabel.font = [UIFont fontWithName:string size:self.argument.blockConfiguration.argumentFont.pointSize];
    } else {
        cell.textLabel.font = self.argument.blockConfiguration.argumentFont;
    }
    cell.textLabel.text = string;
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    self.textField.text = [self.listArgument.listArray objectAtIndex:index];
    [self.listArgument updateIndex:index];
    if ([self.listArgument isKindOfClass:[CPFontArgument class]]) {
        self.textField.font = [UIFont fontWithName:self.textField.text size:self.argument.blockConfiguration.argumentFont.pointSize];
    } else {
        self.textField.font = self.argument.blockConfiguration.argumentFont;
    }
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];    
}

#pragma mark - UITextFieldDelegate implement

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

@end
