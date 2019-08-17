//
//  CPMathFunctionArgument.h
//  DynamicArt
//
//  Created by wangyw on 3/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"
#import "CPListArgument.h"

typedef enum {
    CPMathFunctionArgumentTypeAbs,
    CPMathFunctionArgumentTypeSqrt,
    CPMathFunctionArgumentTypeSin,
    CPMathFunctionArgumentTypeCos,
    CPMathFunctionArgumentTypeTan,
    CPMathFunctionArgumentTypeAsin,
    CPMathFunctionArgumentTypeAcos,
    CPMathFunctionArgumentTypeAtan,
    CPMathFunctionArgumentTypeLn,
    CPMathFunctionArgumentTypeLog,
    CPMathFunctionArgumentTypeRound,
    CPMathFunctionArgumentTypeFloor,
    CPMathFunctionArgumentTypeCeil,
    CPMathFunctionArgumentNumberOfTypes
} CPMathFunctionArgumentType;

@interface CPMathFunctionArgument : CPListArgument <CPCacheItem>

@end
