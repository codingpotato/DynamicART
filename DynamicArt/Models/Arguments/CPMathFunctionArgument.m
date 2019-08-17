//
//  CPMathFunctionArgument.m
//  DynamicArt
//
//  Created by wangyw on 3/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMathFunctionArgument.h"

@implementation CPMathFunctionArgument

static NSArray *_mathFunctions;

+ (void)releaseCache {
    _mathFunctions = nil;
}

- (NSArray *)listArray {
    if (!_mathFunctions) {
        _mathFunctions = [NSArray arrayWithObjects:@"abs", @"sqrt", @"sin", @"cos", @"tan", @"asin", @"acos", @"atan", @"ln", @"log", @"round", @"floor", @"ceil", nil];
        [CPCacheManager addCachedClass:[CPMathFunctionArgument class]];

        NSAssert(_mathFunctions.count == CPMathFunctionArgumentNumberOfTypes, @"");
    }
    return _mathFunctions;
}

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:self.currentText];
}

@end
