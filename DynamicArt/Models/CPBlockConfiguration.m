//
//  CPBlockConfiguration.m
//  DynamicArt
//
//  Created by wangyw on 4/5/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlockConfiguration.h"

#import "CPExpression.h"
#import "CPImageCache.h"
#import "CPHeadStatement.h"

@interface CPBlockConfiguration ()

+ (NSMutableDictionary *)blockConfigurations;

@end

@implementation CPBlockConfiguration

#pragma mark - property methods

- (CGFloat)leftOfPlugCenter {
    return 25.0;
}

- (CGFloat)heightOfPlugCenter {
    return 5.0;
}

- (CGFloat)widthOfLeftBar {
    return 20.0;
}

- (CGFloat)heightOfInnerSpace {
    return 10.0;
}

- (CGFloat)heightOfPlugImage {
    static CGFloat heightOfPlugImage = 0.0;
    if (heightOfPlugImage == 0.0) {
        heightOfPlugImage = self.plugImage.size.height;
    }
    return heightOfPlugImage;
}

- (CGFloat)heightOfNoSocketImage {
    static CGFloat heightOfNoSocketImage = 0.0;
    if (heightOfNoSocketImage == 0.0) {
        heightOfNoSocketImage = self.noSocketImage.size.height;
    }
    return heightOfNoSocketImage;
}

- (CGFloat)heightOfInnerSocketImage {
    static CGFloat heightOfInnerSocketImage = 0.0;
    if (heightOfInnerSocketImage == 0.0) {
        heightOfInnerSocketImage = self.innerSocketImage.size.height;
    }
    return heightOfInnerSocketImage;
}

- (CGFloat)heightOfInnerBottomSocketImage {
    static CGFloat heightOfInnerBottomSocketImage = 0.0;
    if (heightOfInnerBottomSocketImage == 0.0) {
        heightOfInnerBottomSocketImage = self.innerBottomSocketImage.size.height;
    }
    return heightOfInnerBottomSocketImage;
}

- (CGFloat)heightOfSocketImage {
    static CGFloat heightOfSocketImage = 0.0;
    if (heightOfSocketImage == 0.0) {
        heightOfSocketImage = self.socketImage.size.height;
    }
    return heightOfSocketImage;
}

- (CGFloat)heightOfExpressionImage {
    static CGFloat heightOfExpressionImage = 0.0;
    if (heightOfExpressionImage == 0.0) {
        heightOfExpressionImage = self.expressionImage.size.height;
    }
    return heightOfExpressionImage;
}

- (CGFloat)leftOfFirstArgument {
    return 20.0;
}

- (CGFloat)widthBetweenTwoArguments {
    return 8.0;
}

- (UIFont *)argumentFont {
    return [UIFont systemFontOfSize:21.0];
}

- (NSString *)colorString {
    switch (self.color) {
        case CPBlockConfigurationColorNone:return @"";
        case CPBlockConfigurationColorOrange:return @"orange";
        case CPBlockConfigurationColorBlue:return @"blue";
        case CPBlockConfigurationColorGreen:return @"green";
        case CPBlockConfigurationColorPink:return @"pink";
        case CPBlockConfigurationColorBrown:return @"brown";
        default:
            NSAssert(NO, @"");
            return nil;
    }
}

- (UIImage *)plugImage {
    if ([self.blockClass isSubclassOfClass:[CPHeadStatement class]]) {
        return [CPImageCache headImage];
    } else {
        return [CPImageCache plugImageOfColor:self.colorString];
    }
}

- (UIImage *)innerSocketImage {
    return [CPImageCache innerSocketImageOfColor:self.colorString];
}

- (UIImage *)innerBottomSocketImage {
    return [CPImageCache innerBottomSocketImageOfColor:self.colorString];
}

- (UIImage *)socketImage {
    return [CPImageCache socketImageOfColor:self.colorString];
}

- (UIImage *)noSocketImage {
    return [CPImageCache noSocketImageOfColor:self.colorString];
}

- (UIImage *)expressionImage {
    return [CPImageCache expressionImageOfResultClass:self.resultClass];
}

#pragma mark - private property methods

static NSMutableDictionary *_blockConfigurations;

+ (NSMutableDictionary *)blockConfigurations {
    if (!_blockConfigurations) {
        _blockConfigurations = [[NSMutableDictionary alloc] init];
    }
    return _blockConfigurations;
}

#pragma mark - class methods

+ (CPBlockConfiguration *)configurationForBlock:(Class)blockClass {
    return [[self blockConfigurations] objectForKey:(id<NSCopying>)blockClass];
}

+ (void)setConfiguration:(CPBlockConfiguration *)configuration forBlock:(Class)blockClass {
    [[self blockConfigurations] setObject:configuration forKey:(id<NSCopying>)blockClass];
}

#pragma mark - init methods

- (id)initWithStatementClass:(Class)statementClass color:(CPBlockConfigurationColor)color numberOfSockets:(int)numberOfSockets syntaxArgumentClasses:(NSArray *)syntaxArgumentClasses defaultValueOfArguments:(NSArray *)defaultValueOfArguments {
    NSAssert1([statementClass isSubclassOfClass:[CPStatement class]], @"%@ should be subclass of CPStatement", statementClass);
    
    self = [super init];
    if (self) {
        _blockClass = statementClass;
        _color = color;
        _numberOfSockets = numberOfSockets;
        _resultClass = nil;
        _syntaxArgumentClasses = syntaxArgumentClasses;
        _defaultValueOfArguments = defaultValueOfArguments;
        
        NSString *key = [NSString stringWithFormat:@"%@ArgumentsDescription", NSStringFromClass(_blockClass)];
        _argumentsDescription = NSLocalizedStringFromTable(key, @"CPArgumentsDescription", @"argument description");
        NSAssert(_argumentsDescription && ![_argumentsDescription isEqualToString:@""], @"");
    }
    return self;
}

- (id)initWithExpressionClass:(Class)expressionClass resultClass:(Class)resultClass syntaxArgumentClasses:(NSArray *)syntaxArgumentClasses defaultValueOfArguments:(NSArray *)defaultValueOfArguments {
    NSAssert1([expressionClass isSubclassOfClass:[CPExpression class]], @"%@ should be subclass of CPExpression", expressionClass);
    
    self = [super init];
    if (self) {
        _blockClass = expressionClass;
        _color = CPBlockConfigurationColorNone;
        _numberOfSockets = 0;
        _resultClass = resultClass;
        _syntaxArgumentClasses = syntaxArgumentClasses;
        _defaultValueOfArguments = defaultValueOfArguments;
        
        NSString *key = [NSString stringWithFormat:@"%@ArgumentsDescription", NSStringFromClass(_blockClass)];
        _argumentsDescription = NSLocalizedStringFromTable(key, @"CPArgumentsDescription", @"argument description");
        NSAssert(_argumentsDescription && ![_argumentsDescription isEqualToString:@""], @"");
    }
    return self;
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    _blockConfigurations = nil;
}

@end
