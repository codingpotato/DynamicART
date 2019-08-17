//
//  CPVariableView.m
//  Polymer
//
//  Created by wangyw on 3/9/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLeftValueArgumentView.h"

#import "CPImageCache.h"
#import "CPInputFieldManager.h"
#import "CPLeftValueArgument.h"
#import "CPLeftValueVariableInputField.h"

@interface CPLeftValueArgumentView ()

- (CPLeftValueArgument *)leftValueArgument;

@end

@implementation CPLeftValueArgumentView

- (id)initWithArgument:(CPArgument *)argument{
    self = [super initWithArgument:argument];
    if (self) {        
        self.image = [CPImageCache variableArgumentBackgroundImage];
        self.textLabel.text = self.leftValueArgument.variableName;
    }
    return self;
}

- (CPLeftValueArgument *)leftValueArgument {
    return (CPLeftValueArgument *)self.argument;
}

- (BOOL)labelShouldBeginEditing:(CPLabel *)label {
    self.textLabel.hidden = YES;
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:[CPLeftValueVariableInputField class] forArgumentView:self];
    return YES;
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    self.textLabel.text = self.leftValueArgument.variableName;
    self.textLabel.hidden = NO;
}

@end
