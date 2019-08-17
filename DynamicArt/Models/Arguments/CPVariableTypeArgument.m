//
//  CPVariableTypeArgument.m
//  DynamicArt
//
//  Created by wangyw on 11/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPVariableTypeArgument.h"

@implementation CPVariableTypeArgument

static NSArray *_variableTypes;

+ (void)releaseCache {
    _variableTypes = nil;
}

- (NSArray *)listArray {
    if (!_variableTypes) {
        _variableTypes = [NSArray arrayWithObjects:@"Boolean", @"Color", @"Number", @"String", nil];
        [CPCacheManager addCachedClass:[CPVariableTypeArgument class]];
        
        NSAssert(_variableTypes.count == CPVariableTypeNumberOfTypes, @"");
    }
    return _variableTypes;
}

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:self.currentText];
}

@end
