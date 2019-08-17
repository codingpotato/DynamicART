//
//  CPBooleanValue.h
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"
#import "CPValue.h"

@interface CPBooleanValue : NSObject <CPCacheItem, CPValue>

+ (CPBooleanValue *)valueWithBoolean:(BOOL)booleanValue;

+ (CPBooleanValue *)trueValue;

+ (CPBooleanValue *)falseValue;

+ (NSArray *)booleanConstants;

@end
