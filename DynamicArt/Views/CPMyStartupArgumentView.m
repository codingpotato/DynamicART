//
//  CPArgumentView.m
//  DynamicArt
//
//  Created by wangyw on 10/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMyStartupArgumentView.h"

#import "CPImageCache.h"

#import "CPInputFieldManager.h"
#import "CPMyStartupArgument.h"
#import "CPMyStartupInputField.h"

@interface CPMyStartupArgumentView ()

- (CPMyStartupArgument *)startupArgument;

@end

@implementation CPMyStartupArgumentView

- (id)initWithArgument:(CPArgument *)argument {
    self = [super initWithArgument:argument];
    if (self) {
        self.image = [CPImageCache variableArgumentBackgroundImage];
        self.textLabel.text = self.startupArgument.startupName;
    }
    return self;
}

- (CPMyStartupArgument *)startupArgument {
    return (CPMyStartupArgument *)self.argument;
}

- (BOOL)labelShouldBeginEditing:(CPLabel *)label {
    self.textLabel.hidden = YES;
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:[CPMyStartupInputField class] forArgumentView:self];
    return YES;
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    self.textLabel.text = self.startupArgument.startupName;
    self.textLabel.hidden = NO;
}

@end
