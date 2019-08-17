//
//  CPNumberValue.h
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPValue.h"

@interface CPNumberValue : NSObject <CPValue>

+ (double)zeroTolerance;

+ (CPNumberValue *) valueWithDouble:(double)doubleValue;

@end
