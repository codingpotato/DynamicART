//
//  CPImageCache.h
//  DynamicArt
//
//  Created by wangyw on 5/17/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"

@interface CPImageCache : NSObject <CPCacheItem>

+ (UIImage *)headImage;

+ (UIImage *)plugImageOfColor:(NSString *)colorString;
+ (UIImage *)innerSocketImageOfColor:(NSString *)colorString;
+ (UIImage *)innerBottomSocketImageOfColor:(NSString *)colorString;
+ (UIImage *)socketImageOfColor:(NSString *)colorString;
+ (UIImage *)noSocketImageOfColor:(NSString *)colorString;
+ (UIImage *)expressionImageOfResultClass:(Class)resultClass;

+ (UIImage *)variableArgumentBackgroundImage;
+ (UIImage *)rightValueArgumentBackgroundImageForValueClass:(Class)valueClass;
+ (UIImage *)rightValueArgumentVariableBackgroundImageForValueClass:(Class)valueClass;

+ (UIImage *)connectIndicatorImage;

+ (UIImage *)progressBackgroundImage;

+ (UIImage *)keyBackgoundImage;

@end
