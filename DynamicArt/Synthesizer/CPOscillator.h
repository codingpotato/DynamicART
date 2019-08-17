//
//  CPOscillator.h
//  DynamicArt
//
//  Created by wangyw on 12/1/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@interface CPOscillator : NSObject

@property (nonatomic) float frequency;

@property (nonatomic) NSUInteger sampleNum;

- (float)nextValue;

@end

@interface CPSineOscillator : CPOscillator

- (float)valueOfPhase:(float)phase;

@end

@interface CPSquareOscillator : CPOscillator

@end

@interface CPTriangleOscillator : CPOscillator

@end

@interface CPSawToothOscillator : CPOscillator

@end

@interface CPReverseSawToothOscillator : CPOscillator

@end

