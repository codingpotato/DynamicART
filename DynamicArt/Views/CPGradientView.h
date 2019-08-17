//
//  CPGradientView.h
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

typedef enum {
  CPGradientViewTypeBrightness,
  CPGradientViewTypeAlpha
} CPGradientViewType;

@interface CPGradientView : UIView

@property (nonatomic) CPGradientViewType type;

- (void)setHue:(NSUInteger)hue saturation:(NSUInteger)saturation brightness:(NSUInteger)brightness alpha:(NSUInteger)alpha;

@end
