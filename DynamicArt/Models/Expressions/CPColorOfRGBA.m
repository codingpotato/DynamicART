//
//  CPColorOfRGBA.m
//  DynamicArt
//
//  Created by wangyw on 4/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPColorOfRGBA.h"

#import "CPBlockConfiguration.h"
#import "CPColorValue.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPColorOfRGBAArgumentRed,
    CPColorOfRGBAArgumentGreen,
    CPColorOfRGBAArgumentBlue,
    CPColorOfRGBAArgumentAlpha,
    CPColorOfRGBANumberOfArguments
} CPColorOfRGBAArguments;

@implementation CPColorOfRGBA

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:CPColorValueComponentMax], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPColorValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argumentRed = [self.syntaxOrderArguments objectAtIndex:CPColorOfRGBAArgumentRed];
    CPRightValueStrongTypeArgument *argumentGreen = [self.syntaxOrderArguments objectAtIndex:CPColorOfRGBAArgumentGreen];
    CPRightValueStrongTypeArgument *argumentBlue = [self.syntaxOrderArguments objectAtIndex:CPColorOfRGBAArgumentBlue];
    CPRightValueStrongTypeArgument *argumentAlpha = [self.syntaxOrderArguments objectAtIndex:CPColorOfRGBAArgumentAlpha];
    return [CPColorValue valueWithRed:[argumentRed calculateResult].intValue green:[argumentGreen calculateResult].intValue blue:[argumentBlue calculateResult].intValue alpha:[argumentAlpha calculateResult].intValue];
}

@end
