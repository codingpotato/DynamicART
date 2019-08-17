//
//  CPMathFunctionArgumentView.m
//  Polymer
//
//  Created by wangyw on 3/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPListArgumentView.h"

#import "CPBlockConfiguration.h"
#import "CPImageCache.h"
#import "CPInputFieldManager.h"
#import "CPFontArgument.h"
#import "CPListInputField.h"
#import "CPListArgument.h"

@interface CPListArgument ()

- (CPListArgument *)listArgument;

@end

@implementation CPListArgumentView

- (id)initWithArgument:(CPArgument *)argument {
    self = [super initWithArgument:argument];
    if (self) {        
        self.image = [CPImageCache variableArgumentBackgroundImage];
        self.textLabel.text = self.listArgument.currentText;
        if ([self.listArgument isKindOfClass:[CPFontArgument class]]) {
            self.textLabel.font = [UIFont fontWithName:self.textLabel.text size:self.argument.blockConfiguration.argumentFont.pointSize];
        }
    }
    return self;
}

- (CPListArgument *)listArgument {
    return (CPListArgument *)self.argument;
}

- (BOOL)labelShouldBeginEditing:(CPLabel *)label {
    self.textLabel.hidden = YES;
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:[CPListInputField class] forArgumentView:self];
    return YES;
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    self.textLabel.text = self.listArgument.currentText;
    if ([self.listArgument isKindOfClass:[CPFontArgument class]]) {
        self.textLabel.font = [UIFont fontWithName:self.textLabel.text size:self.argument.blockConfiguration.argumentFont.pointSize];
    }
    self.textLabel.hidden = NO;
}

@end
