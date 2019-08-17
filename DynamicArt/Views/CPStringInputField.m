//
//  CPStringInputField.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPStringInputField.h"

#import "CPBlockConfiguration.h"
#import "CPInputFieldManager.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPStringValue.h"

@interface CPStringInputField ()

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument;

- (NSMutableArray *)stringCache;

- (void)cacheString:(NSString *)string;

@end

@implementation CPStringInputField

- (CPRightValueWeakTypeArgument *)rightValueWeakTypeArgument {
    NSAssert([self.argument isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");
    return (CPRightValueWeakTypeArgument *)self.argument;
}

- (void)willShow {
    if (![self.rightValueWeakTypeArgument.value isKindOfClass:[CPStringValue class]]) {
        [self.rightValueWeakTypeArgument updateValue:[CPStringValue valueWithString:self.textField.text]];
    }
    self.textField.font = self.argument.blockConfiguration.argumentFont;
    self.textField.text = self.rightValueWeakTypeArgument.value.stringValue;
    [self cacheString:self.textField.text];
}

- (CGSize)contentSizeOfAutoCompleteView {
    return CGSizeMake(200.0, 500.0);
}

- (int)numberOfRowsForAutoCompleteView {
    return (int)self.stringCache.count;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    cell.textLabel.text = [self.stringCache objectAtIndex:index];
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    NSAssert(index >= 0 && index < self.stringCache.count, @"");

    self.textField.text = [self.stringCache objectAtIndex:index];
    [[CPInputFieldManager defaultInputFieldManager] hideCurrentInputField];
}

#pragma mark - UITextFieldDelegate implement

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.rightValueWeakTypeArgument updateValue:[CPStringValue valueWithString:textField.text]];
    [self cacheString:textField.text];
}

#pragma mark - string cache implement

static NSMutableArray *_stringCache;
static const int cacheSize = 10;

+ (void)releaseCache {
    _stringCache = nil;
}

- (NSMutableArray *)stringCache {
    if (!_stringCache) {
        _stringCache = [NSMutableArray arrayWithCapacity:cacheSize];
        [CPCacheManager addCachedClass:self.class];
    }
    return _stringCache;
}

- (void)cacheString:(NSString *)string {
    if (string && ![string isEqualToString:@""]) {
        for (NSString *cachedString in self.stringCache) {
            if ([cachedString isEqualToString:string]) {
		return;
            }
        }
        while (self.stringCache.count >= cacheSize) {
	    [self.stringCache removeObjectAtIndex:self.stringCache.count - 1];
        }
        [self.stringCache insertObject:string atIndex:0];
    }
}

@end
