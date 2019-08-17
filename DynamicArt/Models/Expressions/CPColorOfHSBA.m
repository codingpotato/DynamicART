//
//  CPColorOfHSBA.m
//  DynamicArt
//
//  Created by wangyw on 10/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPColorOfHSBA.h"

#import "CPBlockConfiguration.h"
#import "CPColorValue.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPColorOfHSBAArgumentRed,
    CPColorOfHSBAArgumentGreen,
    CPColorOfHSBAArgumentBlue,
    CPColorOfHSBAArgumentAlpha,
    CPColorOfHSBANumberOfArguments
} CPColorOfHSBAArguments;

@implementation CPColorOfHSBA

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:CPColorValueComponentMax], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPColorValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argumentHue = [self.syntaxOrderArguments objectAtIndex:CPColorOfHSBAArgumentRed];
    CPRightValueStrongTypeArgument *argumentSaturation = [self.syntaxOrderArguments objectAtIndex:CPColorOfHSBAArgumentGreen];
    CPRightValueStrongTypeArgument *argumentBrightness = [self.syntaxOrderArguments objectAtIndex:CPColorOfHSBAArgumentBlue];
    CPRightValueStrongTypeArgument *argumentAlpha = [self.syntaxOrderArguments objectAtIndex:CPColorOfHSBAArgumentAlpha];

    return [CPColorValue valueWithHue:[argumentHue calculateResult].intValue saturation:[argumentSaturation calculateResult].intValue brightness:[argumentBrightness calculateResult].intValue alpha:[argumentAlpha calculateResult].intValue];
}

@end
