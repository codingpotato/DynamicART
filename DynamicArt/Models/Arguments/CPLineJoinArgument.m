//
//  CPLineJoinArgument.m
//  DynamicArt
//
//  Created by wangyw on 11/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLineJoinArgument.h"

@implementation CPLineJoinArgument

static NSArray *_lineJoinType;

+ (void)releaseCache {
    _lineJoinType = nil;
}

- (NSArray *)listArray {
    if (!_lineJoinType) {
        _lineJoinType = [NSArray arrayWithObjects:@"Miter", @"Round", @"Bevel", nil];
        [CPCacheManager addCachedClass:[CPLineJoinArgument class]];
        
        NSAssert(_lineJoinType.count == CPLineJoinTypeNumberOfTypes, @"");
    }
    return _lineJoinType;
}

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:self.currentText];
}

@end
