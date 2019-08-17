//
//  CPPointInRect.m
//  DynamicArt
//
//  Created by wangyw on 10/3/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPointInRect.h"

#import "CPBooleanValue.h"
#import "CPBlockConfiguration.h"
#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

typedef enum {
    CPPointInRectArgumentPointX,
    CPPointInRectArgumentPointY,
    CPPointInRectArgumentX,
    CPPointInRectArgumentY,
    CPPointInRectArgumentWidth,
    CPPointInRectArgumentHeight,
    CPPointInRectNumberOfArguments
} CPPointInRectArguments;

@implementation CPPointInRect

- (CPBlockConfiguration *)createConfiguration {
    NSArray *syntaxArgumentClasses = [NSArray arrayWithObjects:[CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], [CPRightValueStrongTypeArgument class], nil];
    NSArray *defaultValueOfArguments = [NSArray arrayWithObjects:[CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:0.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:100.0], [CPNumberValue valueWithDouble:200.0], [CPNumberValue valueWithDouble:200.0], nil];
    return [[CPBlockConfiguration alloc] initWithExpressionClass:self.class resultClass:[CPBooleanValue class] syntaxArgumentClasses:syntaxArgumentClasses defaultValueOfArguments:defaultValueOfArguments];
}

- (id<CPValue>)calculateResult {
    CPRightValueStrongTypeArgument *argumentPointX = [self.syntaxOrderArguments objectAtIndex:CPPointInRectArgumentPointX];
    CPRightValueStrongTypeArgument *argumentPointY = [self.syntaxOrderArguments objectAtIndex:CPPointInRectArgumentPointY];
    CPRightValueStrongTypeArgument *argumentX = [self.syntaxOrderArguments objectAtIndex:CPPointInRectArgumentX];
    CPRightValueStrongTypeArgument *argumentY = [self.syntaxOrderArguments objectAtIndex:CPPointInRectArgumentY];
    CPRightValueStrongTypeArgument *argumentWidth = [self.syntaxOrderArguments objectAtIndex:CPPointInRectArgumentWidth];
    CPRightValueStrongTypeArgument *argumentHeight = [self.syntaxOrderArguments objectAtIndex:CPPointInRectArgumentHeight];
    double pointX = [argumentPointX calculateResult].doubleValue;
    double pointY = [argumentPointY calculateResult].doubleValue;
    double x = [argumentX calculateResult].doubleValue;
    double y = [argumentY calculateResult].doubleValue;
    double width = [argumentWidth calculateResult].doubleValue;
    double height = [argumentHeight calculateResult].doubleValue;
    BOOL result = x <= pointX && pointX < x + width && y <= pointY && pointY < y + height;
    return [CPBooleanValue valueWithBoolean:result];
}

@end
