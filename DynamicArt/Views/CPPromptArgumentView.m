//
//  CPPromptArgumentView.m
//  Polymer
//
//  Created by wangyw on 4/5/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPromptArgumentView.h"

#import "CPBlockConfiguration.h"
#import "CPPromptArgument.h"
#import "CPValue.h"

@interface CPPromptArgumentView ()

@property (weak, nonatomic, readonly) CPPromptArgument *promptArgument;

@end

@implementation CPPromptArgumentView

- (id)initWithArgument:(CPArgument *)argument {
    NSAssert([argument isKindOfClass:[CPPromptArgument class]], @"");
    
    self = [super init];
    if (self) {
        _promptArgument = (CPPromptArgument *)argument;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = self.promptArgument.blockConfiguration.argumentFont;
        self.text = self.promptArgument.text;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.shadowColor = [UIColor blackColor];
        self.shadowOffset = CGSizeMake(0.0, -1.0);
        [self adjustFrame];
    }
    return self;
}

- (void)adjustFrame {
    self.frame = self.promptArgument.frame;
}

- (void)removeObservers {
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    [self doesNotRecognizeSelector:_cmd];
}

@end
