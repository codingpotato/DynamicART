//
//  CPValue.h
//  DynamicArt
//
//  Created by wangyw on 3/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

extern NSString *CPValueEncodingKeyValue;

@protocol CPValue <NSObject, NSCoding>

- (int)intValue;

- (double)doubleValue;

- (NSString *)stringValue;

- (BOOL)booleanValue;

- (UIColor *)uiColor;

- (unichar)headTag;

- (unichar)tailTag;

@end
