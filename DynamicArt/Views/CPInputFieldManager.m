//
//  CPInputFieldManager.m
//  DynamicArt
//
//  Created by wangyw on 10/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPInputFieldManager.h"

#import "CPArgumentView.h"
#import "CPBooleanInputField.h"
#import "CPColorInputField.h"
#import "CPInputField.h"
#import "CPNumberInputField.h"
#import "CPPopoverManager.h"
#import "CPRightValueStrongTypeArgument.h"
#import "CPRightValueStrongTypeArgumentView.h"
#import "CPRightValueVariableInputField.h"
#import "CPRightValueWeakTypeArgumentView.h"
#import "CPStringInputField.h"

@interface CPInputFieldManager ()

@property (strong, nonatomic) NSMutableDictionary *inputFields;

@property (nonatomic) BOOL currentInputFieldShown;

@property (weak, nonatomic) CPArgumentView *currentArgumentView;

@property (strong, nonatomic) IBOutlet UIView *inputAccessoryView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *inputTypeSegmentControl;

- (CPInputField *)inputFieldOfClass:(Class)inputFieldClass;

- (UIView *)inputAccessoryViewOfClass:(Class)inputFieldClass forArgumentView:(CPArgumentView *)argumentView;

- (NSString *)segmentTitleOfValueClass:(Class)valueClass;

- (Class)valueClassOfInputFieldClass:(Class)inputFieldClass;

- (IBAction)inputTypeChanged:(id)sender;

@end

@implementation CPInputFieldManager

#pragma mark - property methods

- (NSMutableDictionary *)inputFields {
    if (!_inputFields) {
        _inputFields = [[NSMutableDictionary alloc] init];
    }
    return _inputFields;
}

#pragma mark - class methods

static CPInputFieldManager *_defaultInputFieldManager;

+ (CPInputFieldManager *)defaultInputFieldManager {
    if (!_defaultInputFieldManager) {
        _defaultInputFieldManager = [[CPInputFieldManager alloc] init];
    }
    return _defaultInputFieldManager;
}

#pragma mark - public methods

- (Class)inputFieldClassOfValueClass:(Class)valueClass {
    Class inputFieldClass = NSClassFromString([NSStringFromClass(valueClass) stringByReplacingOccurrencesOfString:@"Value" withString:@"InputField"]);
    NSAssert(inputFieldClass, @"");
    return inputFieldClass;
}

- (void)showInputFieldOfClass:(Class)inputFieldClass forArgumentView:(CPArgumentView *)argumentView {
    NSAssert([inputFieldClass isSubclassOfClass:[CPInputField class]], @"");
    NSAssert(argumentView, @"");
    
    [self hideCurrentInputField];
    self.currentInputFieldShown = YES;

    self.currentArgumentView = argumentView;
    self.currentInputField = [self inputFieldOfClass:inputFieldClass];
    self.currentInputField.argument = argumentView.argument;
    UIView *inputAccessoryView = [self inputAccessoryViewOfClass:inputFieldClass forArgumentView:argumentView];
    if (inputAccessoryView) {
        if ([self.currentInputField isKindOfClass:[CPColorInputField class]]) {
            CPColorInputView *colorInputView = ((CPColorInputField *)self.currentInputField).colorInputView;
            colorInputView.inputAccessoryView = inputAccessoryView;
        } else {
            NSAssert([self.currentInputField isKindOfClass:[CPTextInputField class]], @"");
            UITextField *textField = ((CPTextInputField *)self.currentInputField).textField;
            textField.inputAccessoryView = inputAccessoryView;
        }
    }
    [self.currentInputField willShow];
    [argumentView addSubview:self.currentInputField.view];
    [self adjustFrame];
    [self.currentInputField.view becomeFirstResponder];
    
    [self.delegate inputFieldManager:self didShowInputField:self.currentInputField];
}

/*
 * hide current input field only when input field is shown
 * avoid call resignFirstResponder while re-enter
 */
- (void)hideCurrentInputField {
    if (self.currentInputFieldShown) {
        self.currentInputFieldShown = NO;
        [self.delegate inputFieldManager:self willHideInputField:self.currentInputField];
        
        [self.currentInputField.view resignFirstResponder];
        [self.currentInputField.view removeFromSuperview];
        self.currentInputField.argument = nil;
        self.currentInputField = nil;
        [self.currentArgumentView inputFieldWillEndEditing:self.currentInputField];
        self.currentArgumentView = nil;
    }
}

/*
 * adjust frame of input field only when input field is shown
 */
- (void)adjustFrame {
    if (self.currentInputField && self.currentArgumentView) {
        self.currentInputField.view.frame = self.currentArgumentView.bounds;
    }
}

- (void)autoCompleteViewDismissed {
    [self hideCurrentInputField];
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    if (!_defaultInputFieldManager.currentInputField) {
        _defaultInputFieldManager = nil;
    }
}

#pragma mark - private methods

- (CPInputField *)inputFieldOfClass:(Class)inputFieldClass {
    CPInputField *inputField = [self.inputFields objectForKey:(id<NSCopying>)inputFieldClass];
    if (!inputField) {
        inputField = [[inputFieldClass alloc] init];
        [self.inputFields setObject:inputField forKey:(id<NSCopying>)inputFieldClass];
    }
    NSAssert(inputField, @"");
    return inputField;
}

- (UIView *)inputAccessoryViewOfClass:(Class)inputFieldClass forArgumentView:(CPArgumentView *)argumentView {
    if ([argumentView isKindOfClass:[CPRightValueWeakTypeArgumentView class]] || [argumentView isKindOfClass:[CPRightValueStrongTypeArgumentView class]]) {
        if (!self.inputAccessoryView) {
            [[NSBundle mainBundle] loadNibNamed:@"CPInputAccessoryView" owner:self options:nil];
        }
        if ([argumentView isKindOfClass:[CPRightValueStrongTypeArgumentView class]]) {
            [self.inputTypeSegmentControl removeAllSegments];
            [self.inputTypeSegmentControl insertSegmentWithTitle:@"Variable" atIndex:0 animated:NO];
            Class valueClass = ((CPRightValueStrongTypeArgument *)(argumentView.argument)).valueClass;
            [self.inputTypeSegmentControl insertSegmentWithTitle:[self segmentTitleOfValueClass:valueClass] atIndex:0 animated:NO];
            if ([inputFieldClass isSubclassOfClass:[CPRightValueVariableInputField class]]) {
                self.inputTypeSegmentControl.selectedSegmentIndex = 1;
            } else {
                self.inputTypeSegmentControl.selectedSegmentIndex = 0;
            }
        } else {
            if (self.inputTypeSegmentControl.numberOfSegments != 5) {
                [self.inputTypeSegmentControl removeAllSegments];
                [self.inputTypeSegmentControl insertSegmentWithTitle:@"Variable" atIndex:0 animated:NO];
                [self.inputTypeSegmentControl insertSegmentWithTitle:@"String" atIndex:0 animated:NO];
                [self.inputTypeSegmentControl insertSegmentWithTitle:@"Number" atIndex:0 animated:NO];
                [self.inputTypeSegmentControl insertSegmentWithTitle:@"Color" atIndex:0 animated:NO];
                [self.inputTypeSegmentControl insertSegmentWithTitle:@"Boolean" atIndex:0 animated:NO];
            }
            if ([inputFieldClass isSubclassOfClass:[CPRightValueVariableInputField class]]) {
                self.inputTypeSegmentControl.selectedSegmentIndex = 4;
            } else if ([inputFieldClass isSubclassOfClass:[CPStringInputField class]]) {
                self.inputTypeSegmentControl.selectedSegmentIndex = 3;
            } else if ([inputFieldClass isSubclassOfClass:[CPNumberInputField class]]) {
                self.inputTypeSegmentControl.selectedSegmentIndex = 2;
            } else if ([inputFieldClass isSubclassOfClass:[CPColorInputField class]]) {
                self.inputTypeSegmentControl.selectedSegmentIndex = 1;
            } else if ([inputFieldClass isSubclassOfClass:[CPBooleanInputField class]]) {
                self.inputTypeSegmentControl.selectedSegmentIndex = 0;
            }
        }
        return self.inputAccessoryView;
    } else {
        return nil;
    }
}

- (NSString *)segmentTitleOfValueClass:(Class)valueClass {
    return [[NSStringFromClass(valueClass) stringByReplacingOccurrencesOfString:@"CP" withString:@""] stringByReplacingOccurrencesOfString:@"Value" withString:@""];
}

- (Class)valueClassOfInputFieldClass:(Class)inputFieldClass {
    return NSClassFromString([NSStringFromClass(inputFieldClass) stringByReplacingOccurrencesOfString:@"InputField" withString:@"Value"]);
}

- (IBAction)inputTypeChanged:(id)sender {
    NSAssert([self.currentArgumentView isKindOfClass:[CPRightValueWeakTypeArgumentView class]] || [self.currentArgumentView isKindOfClass:[CPRightValueStrongTypeArgumentView class]], @"");
    [self.currentArgumentView inputTypeChangedTo:(int)self.inputTypeSegmentControl.selectedSegmentIndex];
}

@end
