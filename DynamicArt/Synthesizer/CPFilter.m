//
//  CPFilter.m
//  DynamicArt
//
//  Created by wangyw on 12/1/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPFilter.h"

#import "CPSynthesizer.h"

static const float _kE = 2.71828183f;

@implementation CPFilter

- (float)valueFilteredFromValue:(float)value {
    [self doesNotRecognizeSelector:_cmd];
    return 0.0;
}

@end

@interface CPLowPassFilter () {
@private
    float _x1;      // input value x[k-1]
    float _x2;      // input value x[k-2]
    float _y1;      // output value y[k-1]
    float _y2;      // output value y[k-2]
    
    float _a0;      // filter coefficients
    float _a1;
    float _a2;
    float _b1;
    float _b2;
}

@end

@implementation CPLowPassFilter

- (void)setCutOffFrequency:(float)cutOffFrequency {
    [super setCutOffFrequency:cutOffFrequency];
    
    float n = 1;                                    // Number of filter passes
    float f0 = cutOffFrequency;                     // 3dB cutoff frequency
    const float fs = [CPSynthesizer sampleRate];
    float c = powf(powf(2, 1.0 / n) - 1, -0.25);    // 3dB cutoff correction
    float g = 1;                                    // Polynomial coefficients
    float p = sqrtf(2);
    float fp = c * (f0 / fs);                       // Corrected cutoff frequency
    float w0 = tanf(M_PI * fp);                     // Warp cutoff freq from analog to digital domain
    float k1 = p * w0;                              // Calculate the filter co-efficients
    float k2 = g * w0 * w0;
    
    _a0 = k2 / (1 + k1 + k2);
    _a1 = 2 * _a0;
    _a2 = _a0;
    _b1 = 2 * _a0 * (1 / k2 - 1);
    _b2 = 1 - (_a0 + _a1 + _a2 + _b1);
}

- (float)valueFilteredFromValue:(float)value {
    if (self.cutOffFrequency <= 0.0) {
        return value;
    } else if (self.cutOffFrequency < [CPSynthesizer minFrequency]) {
        return 0.0;
    }
    
    float y = _a0 * value + _a1 * _x1 + _a2 *  _x2 + _b1 * _y1 + _b2 * _y2;
    _x1 = value;
    _x2 = _x1;
    _y2 = _y1;
    _y1 = y;
    return y;
}

@end

@interface CPResonantFilter () {
@private
    float _resonance;
    
    float _y1;
    float _y2;
    float _y3;
    float _y4;
    float _oldx;
    float _oldy1;
    float _oldy2;
    float _oldy3;
}

@end

@implementation CPResonantFilter

- (float)valueFilteredFromValue:(float)value {
    _resonance = 0.0;
    
    float f = 2.0 * self.cutOffFrequency / [CPSynthesizer sampleRate];
    float k = 3.6 * f - 1.6 * f * f - 1;
    float p = (k + 1.0) * 0.5;
    float scale = powf(_kE, (1.0 - p) * 1.386249);
    float r = _resonance * scale;
    
    float out = value - r * _y4;
    _y1 = out * p + _oldx * p - k * _y1;
    _y2 = _y1 * p + _oldy1 * p - k * _y2;
    _y3 = _y2 * p + _oldy2 * p - k * _y3;
    _y4 = _y3 * p + _oldy3 * p - k * _y4;
    _y4 = _y4 - powf(_y4, 3.0f) / 6.0f;
    _oldx = out;
    _oldy1 = _y1;
    _oldy2 = _y2;
    _oldy3 = _y3;
    return out;
}

@end
