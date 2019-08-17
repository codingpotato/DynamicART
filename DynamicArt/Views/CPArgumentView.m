//
//  CPArgumentView.m
//  Polymer
//
//  Created by wang yw on 12-2-25.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgumentView.h"

#import "CPGeometryHelper.h"

#import "CPInputField.h"
#import "CPInputFieldManager.h"

#import "CPArgument.h"
#import "CPBlockConfiguration.h"

@interface CPArgumentView ()

@property (strong, nonatomic) UIView *highlightView;

@end

@implementation CPArgumentView

#pragma mark - property methods

- (CPLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[CPLabel alloc] initWithDelegate:self];
        _textLabel.clipsToBounds = YES;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = self.argument.blockConfiguration.argumentFont;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.userInteractionEnabled = YES;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)inputTypeChangedTo:(int)index {
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - CPArgumentView implement

- (id)initWithArgument:(CPArgument *)argument {
    NSAssert(argument, @"argument should not be nil");
    self = [super initWithFrame:argument.frame];
    if (self) {
        _argument = argument;
        self.userInteractionEnabled = YES;
        self.hidden = argument.isHidden;
        [argument addObserver:self forKeyPath:CPArgumentKeyPathConnectedToExpression options:NSKeyValueObservingOptionNew context:nil];
        [argument addObserver:self forKeyPath:CPArgumentKeyPathHidden options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)adjustFrame {
    self.frame = self.argument.frame;
    self.textLabel.frame = self.bounds;
    [[CPInputFieldManager defaultInputFieldManager] adjustFrame];
}

- (void)removeObservers {
    [self.argument removeObserver:self forKeyPath:CPArgumentKeyPathConnectedToExpression];
    [self.argument removeObserver:self forKeyPath:CPArgumentKeyPathHidden];
}

- (void)inputFieldWillEndEditing:(CPInputField *)inputField {
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - observer method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (keyPath == CPArgumentKeyPathConnectedToExpression) {
        if (self.argument.connectedToExpression) {
            if (!self.highlightView) {
                CGRect frame = CPRectEnlarge(self.frame, 5.0);
                self.highlightView = [[UIView alloc] initWithFrame:frame];
                self.highlightView.backgroundColor = [UIColor redColor];
                self.highlightView.alpha = 0.6;
                self.highlightView.layer.cornerRadius = 10.0;
                [self.superview insertSubview:self.highlightView belowSubview:self];
            }
        } else {
            if (self.highlightView) {
                [self.highlightView removeFromSuperview];
                self.highlightView = nil;
            }
        }
    } else if (keyPath == CPArgumentKeyPathHidden) {
        self.hidden = self.argument.isHidden;
    }
}

#pragma mark - CPLabelDelegate implement

- (BOOL)labelShouldBeginEditing:(CPLabel *)label {
    [self doesNotRecognizeSelector:_cmd];
    return YES;
}

@end
