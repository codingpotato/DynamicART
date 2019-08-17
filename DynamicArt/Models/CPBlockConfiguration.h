//
//  CPBlockConfiguration.h
//  DynamicArt
//
//  Created by wangyw on 4/5/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"

typedef enum {
    CPBlockConfigurationColorNone,
    CPBlockConfigurationColorOrange,
    CPBlockConfigurationColorBlue,
    CPBlockConfigurationColorGreen,
    CPBlockConfigurationColorPink,
    CPBlockConfigurationColorBrown,
    CPBlockConfigurationColorNumberOfColors
} CPBlockConfigurationColor;

@interface CPBlockConfiguration : NSObject <CPCacheItem>

@property (weak, nonatomic, readonly) Class blockClass;

@property (nonatomic, readonly) CPBlockConfigurationColor color;

@property (nonatomic, readonly) int numberOfSockets;

@property (weak, nonatomic, readonly) Class resultClass;

@property (strong, nonatomic, readonly) NSArray *syntaxArgumentClasses;

@property (strong, nonatomic, readonly) NSArray *defaultValueOfArguments;

@property (strong, nonatomic, readonly) NSString *argumentsDescription;

@property (nonatomic, readonly) CGFloat leftOfPlugCenter;

@property (nonatomic, readonly) CGFloat heightOfPlugCenter;

@property (nonatomic, readonly) CGFloat widthOfLeftBar;

@property (nonatomic, readonly) CGFloat heightOfInnerSpace;

@property (nonatomic, readonly) CGFloat heightOfPlugImage;

@property (nonatomic, readonly) CGFloat heightOfInnerSocketImage;

@property (nonatomic, readonly) CGFloat heightOfInnerBottomSocketImage;

@property (nonatomic, readonly) CGFloat heightOfSocketImage;

@property (nonatomic, readonly) CGFloat heightOfNoSocketImage;

@property (nonatomic, readonly) CGFloat heightOfExpressionImage;

@property (nonatomic, readonly) CGFloat leftOfFirstArgument;

@property (nonatomic, readonly) CGFloat widthBetweenTwoArguments;

@property (nonatomic, readonly) UIFont *argumentFont;

@property (nonatomic, readonly) NSString *colorString;

@property (nonatomic, readonly) UIImage *plugImage;
@property (nonatomic, readonly) UIImage *innerSocketImage;
@property (nonatomic, readonly) UIImage *innerBottomSocketImage;
@property (nonatomic, readonly) UIImage *socketImage;
@property (nonatomic, readonly) UIImage *noSocketImage;

@property (nonatomic, readonly) UIImage *expressionImage;

+ (CPBlockConfiguration *)configurationForBlock:(Class)blockClass;

+ (void)setConfiguration:(CPBlockConfiguration *)configuration forBlock:(Class)blockClass;

- (id)initWithStatementClass:(Class)statementClass color:(CPBlockConfigurationColor)color numberOfSockets:(int)numberOfSockets syntaxArgumentClasses:(NSArray *)syntaxArgumentClasses defaultValueOfArguments:(NSArray *)defaultValueOfArguments;

- (id)initWithExpressionClass:(Class)expressionClass resultClass:(Class)resultClass syntaxArgumentClasses:(NSArray *)syntaxArgumentClasses defaultValueOfArguments:(NSArray *)defaultValueOfArguments;

@end
