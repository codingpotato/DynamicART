//
//  CPImageCache.m
//  DynamicArt
//
//  Created by wangyw on 5/17/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPImageCache.h"

#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPColorValue.h"
#import "CPNullValue.h"
#import "CPNumberValue.h"
#import "CPStringValue.h"

@interface CPImageCache ()

@property (strong, nonatomic) UIImage *headImage;
@property (strong, nonatomic) NSMutableDictionary *plugImages;
@property (strong, nonatomic) NSMutableDictionary *innerSocketImages;
@property (strong, nonatomic) NSMutableDictionary *innerBottomSocketImages;
@property (strong, nonatomic) NSMutableDictionary *socketImages;
@property (strong, nonatomic) NSMutableDictionary *noSocketImages;
@property (strong, nonatomic) NSMutableDictionary *expressionImages;

@property (strong, nonatomic) UIImage *variableArgumentBackgroundImage;
@property (strong, nonatomic) NSMutableDictionary *rightValueArgumentBackgroundImages;
@property (strong, nonatomic) NSMutableDictionary *rightValueArgumentVariableBackgroundImages;

@property (strong, nonatomic) UIImage *connectIndicatorImage;

@property (strong, nonatomic) UIImage *progressBackgroundImage;

@property (strong, nonatomic) UIImage *keyBackgroundImage;

+ (CPImageCache *)defaultImageCache;

@end

@implementation CPImageCache

static CPImageCache *_defaultImageCache;

+ (UIImage *)headImage {
    return [self defaultImageCache].headImage;
}

+ (UIImage *)plugImageOfColor:(NSString *)colorString {
    UIImage *image = [[self defaultImageCache].plugImages objectForKey:colorString];
    if (!image) {
        image = [[UIImage imageNamed:[NSString stringWithFormat:@"plug_%@.png", colorString]] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 65.0, 19.0, 14.0)];
        [[self defaultImageCache].plugImages setObject:image forKey:colorString];
    }
    return image;
}

+ (UIImage *)innerSocketImageOfColor:(NSString *)colorString {
    UIImage *image = [[self defaultImageCache].innerSocketImages objectForKey:colorString];
    if (!image) {
        image = [[UIImage imageNamed:[NSString stringWithFormat:@"inner_socket_%@.png", colorString]] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 65.0, 39.0, 14.0)];
        [[self defaultImageCache].innerSocketImages setObject:image forKey:colorString];
    }
    return image;
}

+ (UIImage *)innerBottomSocketImageOfColor:(NSString *)colorString {
    UIImage *image = [[self defaultImageCache].innerBottomSocketImages objectForKey:colorString];
    if (!image) {
        image = [[UIImage imageNamed:[NSString stringWithFormat:@"inner_bottom_socket_%@.png", colorString]] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 65.0, 14.0, 14.0)];
        [[self defaultImageCache].innerBottomSocketImages setObject:image forKey:colorString];
    }
    return image;
}

+ (UIImage *)socketImageOfColor:(NSString *)colorString {
    UIImage *image = [[self defaultImageCache].socketImages objectForKey:colorString];
    if (!image) {
        image = [[UIImage imageNamed:[NSString stringWithFormat:@"socket_%@.png", colorString]] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 65.0, 7.0, 14.0)];
        [[self defaultImageCache].socketImages setObject:image forKey:colorString];
    }
    return image;
}

+ (UIImage *)noSocketImageOfColor:(NSString *)colorString {
    UIImage *image = [[self defaultImageCache].noSocketImages objectForKey:colorString];
    if (!image) {
        image = [[UIImage imageNamed:[NSString stringWithFormat:@"no_socket_%@.png", colorString]] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 65.0, 7.0, 14.0)];
        [[self defaultImageCache].noSocketImages setObject:image forKey:colorString];
    }
    return image;
}

+ (UIImage *)expressionImageOfResultClass:(Class)resultClass {
    Class class = resultClass ? resultClass : [CPNullValue class];
    UIImage *image = [[self defaultImageCache].expressionImages objectForKey:(id<NSCopying>)class];
    if (!image) {
        NSString *imageName;
        if ([class isSubclassOfClass:[CPNullValue class]]) {
            imageName = @"weak_expression.png";
        } else if ([class isSubclassOfClass:[CPBooleanValue class]]) {
            imageName = @"boolean_expression.png";
        } else if ([class isSubclassOfClass:[CPColorValue class]]) {
            imageName = @"color_expression.png";
        } else if ([class isSubclassOfClass:[CPNumberValue class]]) {
            imageName = @"number_expression.png";
        } else if ([class isSubclassOfClass:[CPStringValue class]]) {
            imageName = @"string_expression.png";
        } else {
            NSAssert(NO, @"");
            return nil;
        }
        image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 15.0, 21.0, 14.0)];
        [[self defaultImageCache].expressionImages setObject:image forKey:(id<NSCopying>)class];
    }
    return image;
}

+ (UIImage *)variableArgumentBackgroundImage {
    return [self defaultImageCache].variableArgumentBackgroundImage;
}

+ (UIImage *)rightValueArgumentBackgroundImageForValueClass:(Class)valueClass {
    UIImage *image = [[self defaultImageCache].rightValueArgumentBackgroundImages objectForKey:(id<NSCopying>)valueClass];
    if (!image) {
        NSString *imageName;
        if ([valueClass isSubclassOfClass:[CPBooleanValue class]]) {
            imageName = @"boolean_argument.png";
        } else if ([valueClass isSubclassOfClass:[CPColorValue class]]) {
            imageName = @"color_argument.png";
        } else if ([valueClass isSubclassOfClass:[CPNumberValue class]]) {
            imageName = @"number_argument.png";
        } else if ([valueClass isSubclassOfClass:[CPStringValue class]]) {
            imageName = @"string_argument.png";
        } else {
            NSAssert(NO, @"");
            return nil;
        }
        image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0, 15.0, 18.0, 14.0)];
        [[self defaultImageCache].rightValueArgumentBackgroundImages setObject:image forKey:(id<NSCopying>)valueClass];
    }
    return image;
}

+ (UIImage *)rightValueArgumentVariableBackgroundImageForValueClass:(Class)valueClass {
    UIImage *image = [[self defaultImageCache].rightValueArgumentVariableBackgroundImages objectForKey:(id<NSCopying>)valueClass];
    if (!image) {
        NSString *imageName;
        if ([valueClass isSubclassOfClass:[CPBooleanValue class]]) {
            imageName = @"boolean_variable_argument.png";
        } else if ([valueClass isSubclassOfClass:[CPColorValue class]]) {
            imageName = @"color_variable_argument.png";
        } else if ([valueClass isSubclassOfClass:[CPNumberValue class]]) {
            imageName = @"number_variable_argument.png";
        } else if ([valueClass isSubclassOfClass:[CPStringValue class]]) {
            imageName = @"string_variable_argument.png";
        } else {
            NSAssert(NO, @"");
            return nil;
        }
        image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0, 15.0, 18.0, 14.0)];
        [[self defaultImageCache].rightValueArgumentVariableBackgroundImages setObject:image forKey:(id<NSCopying>)valueClass];
    }
    return image;
}

+ (UIImage *)connectIndicatorImage {
    return [self defaultImageCache].connectIndicatorImage;
}

+ (UIImage *)progressBackgroundImage {
    return [self defaultImageCache].progressBackgroundImage;
}

+ (UIImage *)keyBackgoundImage {
    return [self defaultImageCache].keyBackgroundImage;
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    _defaultImageCache = nil;
}

#pragma mark - private methods

+ (CPImageCache *)defaultImageCache {
    if (!_defaultImageCache) {
        _defaultImageCache = [[CPImageCache alloc] init];
        [CPCacheManager addCachedClass:self];
    }
    return _defaultImageCache;
}

- (UIImage *)headImage {
    if (!_headImage) {
        _headImage = [[UIImage imageNamed:@"head.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 65.0, 19.0, 14.0)];
    }
    return _headImage;
}

- (NSMutableDictionary *)plugImages {
    if (!_plugImages) {
        _plugImages = [[NSMutableDictionary alloc] initWithCapacity:CPBlockConfigurationColorNumberOfColors];
    }
    return _plugImages;
}

- (NSMutableDictionary *)innerSocketImages {
    if (!_innerSocketImages) {
        _innerSocketImages = [[NSMutableDictionary alloc] initWithCapacity:CPBlockConfigurationColorNumberOfColors];
    }
    return _innerSocketImages;
}

- (NSMutableDictionary *)innerBottomSocketImages {
    if (!_innerBottomSocketImages) {
        _innerBottomSocketImages = [[NSMutableDictionary alloc] initWithCapacity:CPBlockConfigurationColorNumberOfColors];
    }
    return _innerBottomSocketImages;
}

- (NSMutableDictionary *)expressionImages {
    if (!_expressionImages) {
        _expressionImages = [[NSMutableDictionary alloc] init];
    }
    return _expressionImages;
}

- (UIImage *)variableArgumentBackgroundImage {
    if (!_variableArgumentBackgroundImage) {
        _variableArgumentBackgroundImage = [[UIImage imageNamed:@"variable_argument.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0, 15.0, 18.0, 14.0)];
    }
    return _variableArgumentBackgroundImage;
}

- (NSMutableDictionary *)rightValueArgumentBackgroundImages {
    if (!_rightValueArgumentBackgroundImages) {
        _rightValueArgumentBackgroundImages = [[NSMutableDictionary alloc] init];
    }
    return _rightValueArgumentBackgroundImages;
}

- (NSMutableDictionary *)rightValueArgumentVariableBackgroundImages {
    if (!_rightValueArgumentVariableBackgroundImages) {
        _rightValueArgumentVariableBackgroundImages = [[NSMutableDictionary alloc] init];
    }
    return _rightValueArgumentVariableBackgroundImages;
}

- (UIImage *)connectIndicatorImage {
    if (!_connectIndicatorImage) {
        _connectIndicatorImage = [[UIImage imageNamed:@"connect_indicator.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 65.0, 9.0, 14.0)];
    }
    return _connectIndicatorImage;
}

- (UIImage *)progressBackgroundImage {
    if (!_progressBackgroundImage) {
        _progressBackgroundImage = [[UIImage imageNamed:@"progress_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)];
    }
    return _progressBackgroundImage;
}

- (UIImage *)keyBackgroundImage {
    if (!_keyBackgroundImage) {
        _keyBackgroundImage = [[UIImage imageNamed:@"key_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0)];
    }
    return _keyBackgroundImage;
}

@end
