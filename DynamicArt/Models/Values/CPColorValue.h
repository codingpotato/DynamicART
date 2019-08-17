//
//  CPColorValue.h
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPValue.h"

static const double CPColorValueComponentMax = 255.0;

@interface CPColorValue : NSObject <CPValue>

@property (nonatomic) BOOL isHSBA;

@property (nonatomic) NSUInteger red;
@property (nonatomic) NSUInteger green;
@property (nonatomic) NSUInteger blue;

@property (nonatomic) NSUInteger hue;
@property (nonatomic) NSUInteger saturation;
@property (nonatomic) NSUInteger brightness;

@property (nonatomic) NSUInteger alpha;

+ (CPColorValue *)valueWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;

+ (CPColorValue *)valueWithHue:(NSInteger)hue saturation:(NSInteger)saturation brightness:(NSInteger)brightness alpha:(NSInteger)alpha;

+ (CPColorValue *)valueWithUIColor:(UIColor *)uiColor;

@end
