//
//  CPFilter.h
//  DynamicArt
//
//  Created by wangyw on 12/1/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@interface CPFilter : NSObject

@property (nonatomic) float cutOffFrequency;

- (float)valueFilteredFromValue:(float)value;

@end

@interface CPLowPassFilter : CPFilter

@end

@interface CPResonantFilter : CPFilter

@end
