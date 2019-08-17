//
//  CPExpression.h
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlock.h"

@protocol CPValue;

@class CPArgument;

@interface CPExpression : CPBlock

@property (weak, nonatomic) CPArgument *parentArgument;

- (id<CPValue>)calculateResult;

@end
