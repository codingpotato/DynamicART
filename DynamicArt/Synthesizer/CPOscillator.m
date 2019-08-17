//
//  CPOscillator.m
//  DynamicArt
//
//  Created by wangyw on 12/1/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPOscillator.h"

#import "CPSynthesizer.h"

@implementation CPOscillator

- (float)nextValue {
    if (self.frequency < [CPSynthesizer minFrequency] || self.frequency > [CPSynthesizer maxFrequency]) {
        return 0.0;
    }
    float periodSamples = [CPSynthesizer sampleRate] / self.frequency;
    if (periodSamples == 0) {
        return 0.0;
    }
    float value = [self valueOfPhase:self.sampleNum / periodSamples];
    self.sampleNum = (self.sampleNum + 1) % (NSUInteger)periodSamples;
    return value;
}

- (float)valueOfPhase:(float)phase {
    return 0.0;
}

@end

@implementation CPSineOscillator

- (float)valueOfPhase:(float)phase {
    return sinf(2.0 * M_PI * phase);
}

@end

@implementation CPSquareOscillator

- (float)valueOfPhase:(float)phase {
    return phase < 0.5 ? 1.0 : -1.0;
}

@end

@implementation CPTriangleOscillator

- (float)valueOfPhase:(float)phase {
    return 2 * fabs(2 * phase - 2 * floorf(phase) - 1.0) - 1.0;
}

@end

@implementation CPSawToothOscillator

- (float)valueOfPhase:(float)phase {
    return 2 * (phase - floorf(phase) - 0.5);
}

@end

@implementation CPReverseSawToothOscillator

- (float)valueOfPhase:(float)phase {
    return 2 * (floorf(phase) - phase + 0.5);
}

@end
