//
//  CPArrayArgumentView.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArrayArgumentView.h"

#import "CPImageCache.h"

#import "CPInputFieldManager.h"
#import "CPArrayInputField.h"

#import "CPArrayArgument.h"

@interface CPArrayArgumentView ()

- (CPArrayArgument *)arrayArgument;

@end

@implementation CPArrayArgumentView

- (id)initWithArgument:(CPArgument *)argument {
    self = [super initWithArgument:argument];
    if (self) {
        self.image = [CPImageCache variableArgumentBackgroundImage];
        self.textLabel.text = self.arrayArgument.arrayName;
    }
    return self;
}

- (CPArrayArgument *)arrayArgument {
    return (CPArrayArgument *)self.argument;
}

- (BOOL)labelShouldBeginEditing:(CPLabel *)label {
    self.textLabel.hidden = YES;
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:[CPArrayInputField class] forArgumentView:self];
    return YES;
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    self.textLabel.text = self.arrayArgument.arrayName;
    self.textLabel.hidden = NO;
}

@end
