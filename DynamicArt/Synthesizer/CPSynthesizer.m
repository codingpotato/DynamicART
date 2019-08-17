//
//  CPSynthesizer.m
//  DynamicArt
//
//  Created by wangyw on 11/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPSynthesizer.h"

#import <AVFoundation/AVAudioSession.h>

#import "CPFilter.h"
#import "CPOscillator.h"
#import "CPTrace.h"

typedef enum {
    CPSynthesizerStateNone,
    CPSynthesizerStatePlaySound,
    CPSynthesizerStatePlayMusic
} CPSynthesizerState;

@interface CPSynthesizer ()

@property (nonatomic) CPSynthesizerState state;

@property (nonatomic) AudioComponentInstance audioComponentInstance;

@property (strong, nonatomic) CPOscillator *sineOscillator;

@property (strong, nonatomic) CPOscillator *oscillator1;
@property (strong, nonatomic) CPOscillator *oscillator2;

@property (strong, nonatomic) CPLowPassFilter *lowPassFilter;
@property (strong, nonatomic) CPResonantFilter *resonantFilter;

- (void)oneNoteDidFinish:(NSCondition *)condition;

- (void)soundDidFinish:(NSCondition *)condition;

- (float)nextValue;

- (void)audioInit;

@end

@implementation CPSynthesizer

static const float _defaultCutOffFrequency = 5000.0;

static const int _minNote = 1;
static const int _maxNote = 88;
static const int _middleA = 49;
static const int _defaultOctave = 4;
static const float _notesPerOctave = 12.0;
static const float _middleAFrequency = 440.0;
static const float _defaultBeatsPerMinute = 120.0;

#pragma mark - property methods

+ (float)sampleRate {
    return 44100.0;
}

+ (float)minFrequency {
    return 20.0;
}

+ (float)maxFrequency {
    return 20000.0;
}

- (CPOscillator *)sineOscillator {
    if (!_sineOscillator) {
        _sineOscillator = [[CPSineOscillator alloc] init];
    }
    return _sineOscillator;
}

- (CPOscillator *)oscillator1 {
    if (!_oscillator1) {
        _oscillator1 = [[CPTriangleOscillator alloc] init];
    }
    return _oscillator1;
}

- (CPOscillator *)oscillator2 {
    if (!_oscillator2) {
        _oscillator2 = [[CPReverseSawToothOscillator alloc] init];
    }
    return _oscillator2;
}

- (CPLowPassFilter *)lowPassFilter {
    if (!_lowPassFilter) {
        _lowPassFilter = [[CPLowPassFilter alloc] init];
    }
    return _lowPassFilter;
}

- (CPResonantFilter *)resonantFilter {
    if (!_resonantFilter) {
        _resonantFilter = [[CPResonantFilter alloc] init];
    }
    return _resonantFilter;
}

- (NSMutableArray *)notes {
    if (!_notes) {
        _notes = [[NSMutableArray alloc] init];
    }
    return _notes;
}

- (void)dealloc {
    CPTrace(@"%@ dealloc", self);
}

- (void)playSoundByFrequency:(float)frequency timeInterval:(float)timeInterval condition:(NSCondition *)condition {
    if (self.state == CPSynthesizerStateNone && timeInterval > 0) {
        if (self.audioComponentInstance == NULL) {
            [self audioInit];
        }
        
        self.state = CPSynthesizerStatePlaySound;
        frequency = fmaxf([CPSynthesizer minFrequency], frequency);
        frequency = fminf([CPSynthesizer maxFrequency], frequency);
        self.sineOscillator.frequency = frequency;
        self.sineOscillator.sampleNum = 0;
        [self performSelector:@selector(soundDidFinish:) withObject:condition afterDelay:timeInterval];
    } else {
        [self.delegate synthesizerDidFinishSound:self condition:condition];
    }
}

- (void)playMusic:(NSString *)music condition:(NSCondition *)condition {
    if (self.state == CPSynthesizerStateNone && !self.notes.count) {
        NSArray *noteStrings = [music componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        for (NSString *noteString in noteStrings) {
            [self addNoteString:[noteString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
        
        if (self.notes.count > 1) {
            if (self.audioComponentInstance == NULL) {
                [self audioInit];
            }

            self.state = CPSynthesizerStatePlayMusic;
            
            int note = ((NSNumber*)[self.notes objectAtIndex:0]).intValue;
            float noteTime = ((NSNumber*)[self.notes objectAtIndex:1]).floatValue;
            
            float frequency = _middleAFrequency * powf(2, (note - _middleA) / _notesPerOctave);
            self.oscillator1.frequency = frequency;
            self.oscillator1.sampleNum = 0;
            self.oscillator2.frequency = frequency / 2;
            self.oscillator2.sampleNum = 0;
            
            self.lowPassFilter.cutOffFrequency = _defaultCutOffFrequency;
            self.resonantFilter.cutOffFrequency = _defaultCutOffFrequency;
            
            [self.notes removeObjectAtIndex:0];
            [self.notes removeObjectAtIndex:0];
            
            [self performSelector:@selector(oneNoteDidFinish:) withObject:condition afterDelay:noteTime];
        } else {
            [self.delegate synthesizerDidFinishMusic:self condition:condition];
        }
    } else {
        [self.delegate synthesizerDidFinishMusic:self condition:condition];
    }
}

- (void)stop {
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
    
    AudioOutputUnitStop(self.audioComponentInstance);
    AudioUnitUninitialize(self.audioComponentInstance);
}

#pragma mark - private methods

- (void)oneNoteDidFinish:(NSCondition *)condition {
    if (self.notes.count > 1) {
        int note = ((NSNumber*)[self.notes objectAtIndex:0]).intValue;
        float noteTime = ((NSNumber*)[self.notes objectAtIndex:1]).floatValue;
        
        float frequency = _middleAFrequency * powf(2, (note - _middleA) / _notesPerOctave);
        self.oscillator1.frequency = frequency;
        self.oscillator1.sampleNum = 0;
        self.oscillator2.frequency = frequency / 2;
        self.oscillator2.sampleNum = 0;
        
        [self.notes removeObjectAtIndex:0];
        [self.notes removeObjectAtIndex:0];
        
        [self performSelector:@selector(oneNoteDidFinish:) withObject:condition afterDelay:noteTime];
    } else {
        NSAssert(!self.notes.count, @"");
        
        self.state = CPSynthesizerStateNone;
        [self.delegate synthesizerDidFinishMusic:self condition:condition];
    }
}

- (void)soundDidFinish:(NSCondition *)condition {
    self.state = CPSynthesizerStateNone;
    [self.delegate synthesizerDidFinishSound:self condition:condition];
}

- (float)nextValue {
    // use private variable instead of property for avoid sound play issue
    if (self.state == CPSynthesizerStateNone) {
        return 0.0;
    } else if (self.state == CPSynthesizerStatePlaySound) {
        return _sineOscillator.nextValue * 0.8;
    } else {
        // CPSynthesizerStatePlayMusic
        float value = _oscillator1.nextValue * 0.5 + _oscillator2.nextValue * 0.2;
        value = fmaxf(-1.0f, value);
        value = fminf(1.0f, value);
        
        value = [_lowPassFilter valueFilteredFromValue:value];
        value = [_resonantFilter valueFilteredFromValue:value];
        value = fmaxf(-1.0f, value);
        value = fminf(1.0f, value);
        
        return value;
    }
}

OSStatus renderSound(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
    CPSynthesizer *synthesizer = (__bridge CPSynthesizer *)(inRefCon);
    
    // only handle channel 0
	Float32 *buffer = (Float32 *)ioData->mBuffers[0].mData;
	for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        buffer[frame] = synthesizer.nextValue;
	}
	return noErr;
}

- (void)audioInit {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	AudioComponentInstanceNew(defaultOutput, &_audioComponentInstance);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = renderSound;
	input.inputProcRefCon = (__bridge void *)(self);
	AudioUnitSetProperty(self.audioComponentInstance, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, sizeof(input));
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = [CPSynthesizer sampleRate];
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	AudioUnitSetProperty(self.audioComponentInstance, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamFormat, sizeof(AudioStreamBasicDescription));

    AudioUnitInitialize(self.audioComponentInstance);
    AudioOutputUnitStart(self.audioComponentInstance);
}

- (void)addNoteString:(NSString *)noteString {
    noteString = [noteString uppercaseString];
    int noteStringLength = (int)noteString.length;
    if (noteStringLength) {
        int index = 0;
        int octaveUp = 0, octaveDown = 0;
        while (index < noteStringLength) {
            unichar cc = [noteString characterAtIndex:index];
            if (cc == '+') {
                octaveUp++;
            } else if (cc == '-') {
                octaveDown++;
            } else {
                break;
            }
            index++;
        }
        
        unichar noteChar = 0;
        if (index < noteStringLength) {
            noteChar = [noteString characterAtIndex:index];
        }
        int subNote = 0;
        switch (noteChar) {
            case '0':
                index++;
                break;
            case 'A':
                subNote = 9;
                index++;
                break;
            case 'B':
                subNote = 11;
                index++;
                break;
            case 'C':
                subNote = 0;
                index++;
                break;
            case 'D':
                subNote = 2;
                index++;
                break;
            case 'E':
                subNote = 4;
                index++;
                break;
            case 'F':
                subNote = 5;
                index++;
                break;
            case 'G':
                subNote = 7;
                index++;
                break;
            default:
                break;
        }
        int note = (_defaultOctave + octaveUp - octaveDown) * _notesPerOctave + subNote - 8;
        
        unichar noteUpDownChar = 0;
        if (index < noteStringLength) {
            noteUpDownChar = [noteString characterAtIndex:index];
        }
        switch (noteUpDownChar) {
            case '#':
                note++;
                index++;
                break;
            case 'B':
                note--;
                index++;
                break;
            default:
                break;
        }
        note = MAX(_minNote, note);
        note = MIN(_maxNote, note);
        if (noteChar == '0') {
            note = 0;
        }
        
        BOOL half = NO;
        if (index < noteStringLength && [noteString characterAtIndex:noteStringLength - 1] == '.') {
            half = YES;
        }
        
        int noteLength = 0;
        if (index < noteStringLength - (half ? 1 : 0)) {
            NSRange range;
            range.location = index;
            range.length = half ? noteStringLength - 1 - index : noteStringLength - index;
            noteLength = [noteString substringWithRange:range].intValue;
        }
        
        if (noteLength) {
            if (self.beatsPerMinute <= 1.0) {
                self.beatsPerMinute = _defaultBeatsPerMinute;
            }
            float noteTime = 4 * 60.0 / noteLength / self.beatsPerMinute;
            if (half) {
                noteTime *= 1.5;
            }
            
            [self.notes addObject:[NSNumber numberWithInt:note]];
            [self.notes addObject:[NSNumber numberWithFloat:noteTime]];
        }
    }    
}

@end
