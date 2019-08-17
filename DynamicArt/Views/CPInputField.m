//
//  CPInputField.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPInputField.h"

@implementation CPInputField

- (UIView *)view {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)willShow {
    [self doesNotRecognizeSelector:_cmd];
}

- (CGSize)contentSizeOfAutoCompleteView {
    [self doesNotRecognizeSelector:_cmd];
    return CGSizeZero;
}

- (int)numberOfRowsForAutoCompleteView {
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSArray *)filterArray:(NSArray *)array withPrefix:(NSString *)prefix {
    if (!prefix || [prefix isEqualToString:@""]) {
        return array;
    } else {
        return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", prefix]];
    }
}

@end
