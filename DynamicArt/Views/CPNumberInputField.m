//
//  CPNumberInputField.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPNumberInputField.h"

#import "CPBlockConfiguration.h"
#import "CPInputFieldManager.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPNumberValue.h"

@interface CPNumberInputField ()

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument;

- (NSMutableArray *)numberCache;

- (void)cacheNumber:(double)number;

@end

@implementation CPNumberInputField

- (id)init {
    self = [super init];
    if (self) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}

- (void)willShow {
    if (!self.rightValueWeakTypeArgument.value || ![self.rightValueWeakTypeArgument.value isKindOfClass:[CPNumberValue class]]) {
        [self.rightValueWeakTypeArgument updateValue:[CPNumberValue valueWithDouble:self.textField.text.doubleValue]];
    }
    self.textField.font = self.argument.blockConfiguration.argumentFont;
    self.textField.text = self.rightValueWeakTypeArgument.value.stringValue;
    [self cacheNumber:self.textField.text.floatValue];
}

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument {
    NSAssert([self.argument isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");
    return (CPRightValueWeakTypeArgument *)self.argument;
}

- (CGSize)contentSizeOfAutoCompleteView {
    return CGSizeMake(200.0, 500.0);
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)self.numberCache.count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    NSAssert(index >= 0 && index < self.numberCache.count, @"");
    
    NSNumber *number = [self.numberCache objectAtIndex:index];
    cell.textLabel.text = number.stringValue;
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    NSAssert(index >= 0 && index < self.numberCache.count, @"");
    
    NSNumber *number = [self.numberCache objectAtIndex:index];
    self.textField.text = number.stringValue;
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

#pragma mark - UITextFieldDelegate implement

- (void)textFieldDidEndEditing:(UITextField *)textField {
    double value = self.textField.text.doubleValue;
    [self.rightValueWeakTypeArgument updateValue:[CPNumberValue valueWithDouble:value]];
    [self cacheNumber:value];
}

#pragma mark - number cache

static NSMutableArray *_numberCache;

+ (void)releaseCache {
    _numberCache = nil;
}

- (NSMutableArray *)numberCache {
    if (!_numberCache) {
        _numberCache = [NSMutableArray arrayWithCapacity:10];
        [CPCacheManager addCachedClass:self.class];
    }
    return _numberCache;
}

- (void)cacheNumber:(double)number {
    BOOL found = NO;
    for (NSNumber *cachedNumber in self.numberCache) {
        if (cachedNumber.doubleValue == number) {
            found = YES;
            break;
        }
    }
    if (!found) {
        while (self.numberCache.count >= 10) {
            [self.numberCache removeObjectAtIndex:self.numberCache.count - 1];
        }
        [self.numberCache insertObject:[NSNumber numberWithDouble:number] atIndex:0];
    }
}

@end
