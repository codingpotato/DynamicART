//
//  CPPerformArgumentView.m
//  DynamicArt
//
//  Created by wangyw on 10/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPerformArgumentView.h"

#import "CPImageCache.h"
#import "CPInputFieldManager.h"
#import "CPPerformInputField.h"

#import "CPPerformArgument.h"

@interface CPPerformArgumentView ()

- (CPPerformArgument *)performArgument;

@end

@implementation CPPerformArgumentView

- (id)initWithArgument:(CPArgument *)argument {
    self = [super initWithArgument:argument];
    if (self) {
        self.image = [CPImageCache variableArgumentBackgroundImage];
        self.textLabel.text = self.performArgument.startupName;
    }
    return self;
}

- (CPPerformArgument *)performArgument {
    return (CPPerformArgument *)self.argument;
}

- (BOOL)labelShouldBeginEditing:(CPLabel *)label {
    self.textLabel.hidden = YES;
    [[CPInputFieldManager defaultInputFieldManager] showInputFieldOfClass:[CPPerformInputField class] forArgumentView:self];
    return YES;
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    self.textLabel.text = self.performArgument.startupName;
    self.textLabel.hidden = NO;
}

@end
