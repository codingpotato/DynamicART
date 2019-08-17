//
//  CPSynthesizer.h
//  DynamicArt
//
//  Created by wangyw on 11/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPSynthesizer;

@protocol CPSynthesizerDelegate <NSObject>

- (void)synthesizerDidFinishSound:(CPSynthesizer *)synthesizer condition:(NSCondition *)condition;

- (void)synthesizerDidFinishMusic:(CPSynthesizer *)synthesizer condition:(NSCondition *)condition;

@end

@interface CPSynthesizer : NSObject

@property (weak, nonatomic) id<CPSynthesizerDelegate> delegate;

@property (nonatomic) float beatsPerMinute;

@property (strong, nonatomic) NSMutableArray *notes;

+ (float)sampleRate;

+ (float)minFrequency;

+ (float)maxFrequency;

- (void)playSoundByFrequency:(float)frequency timeInterval:(float)timeInterval condition:(NSCondition *)condition;

- (void)playMusic:(NSString *)music condition:(NSCondition *)condition;

- (void)stop;

- (void)addNoteString:(NSString *)noteString;

@end

