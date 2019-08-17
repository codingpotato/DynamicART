//
//  CPFontArgument.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPFontArgument.h"

#import "CPBlockConfiguration.h"

@implementation CPFontArgument

static NSArray *_fontNames;

- (UIFont *)font {
    NSString *fontName = self.currentText;
    return [UIFont fontWithName:fontName size:self.blockConfiguration.argumentFont.pointSize];
}

- (NSArray *)listArray {
    if (!_fontNames) {
        [CPCacheManager addCachedClass:self.class];
        
        NSMutableArray *fontNames = [NSMutableArray array];
        for (NSString *fontFamily in [UIFont familyNames]) {
            [fontNames addObjectsFromArray:[UIFont fontNamesForFamilyName:fontFamily]];
        }
        _fontNames = [fontNames copy];
    }
    return _fontNames;
}

#pragma mark - lifecycle methods

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:@"!"];
    [string appendString:self.currentText];
    [string appendString:@"!"];
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    _fontNames = nil;
}

@end
