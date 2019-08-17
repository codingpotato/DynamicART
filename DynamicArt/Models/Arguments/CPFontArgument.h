//
//  CPFontArgument.h
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"
#import "CPListArgument.h"

@interface CPFontArgument : CPListArgument <CPCacheItem>

- (UIFont *)font;

@end
