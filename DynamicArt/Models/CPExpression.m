//
//  CPExpression.m
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPExpression.h"

#import "CPGeometryHelper.h"

#import "CPArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPValue.h"

@implementation CPExpression

static NSString *_encodingKeyOrigin = @"Origin";

- (BOOL)isTopBlock {
    return self.parentArgument == nil;
}

- (id)initAtOrigin:(CGPoint)origin {
    self = [super initAtOrigin:origin];
    if (self) {
        self.frame = CPRectSetHeight(self.frame, self.configuration.heightOfExpressionImage);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGPoint origin = [aDecoder decodeCGPointForKey:_encodingKeyOrigin];
        /*
         * file saved by retina hardware will have position .5
         * round to interge to avoid unclear picture
         */
        origin.x = round(origin.x);
        origin.y = round(origin.y);
        self.frame = CPRectMoveOriginTo(self.frame, origin);
        self.frame = CPRectSetHeight(self.frame, self.configuration.heightOfExpressionImage);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    if (!self.parentArgument) {
        [aCoder encodeCGPoint:self.frame.origin forKey:_encodingKeyOrigin];
    }
}

- (BOOL)connectedToOtherBlock {
    return self.parentArgument != nil;
}

- (void)detachFromOtherBlock {
    [self.parentArgument detachExpression];
}

- (void)increaseWidthBy:(CGFloat)deltaWidth {
    [super increaseWidthBy:deltaWidth];
    [self.parentArgument setSize:self.frame.size notifyParentBlock:YES];
}

- (CGFloat)centerOfFirstArgumentBar {
    return self.frame.size.height / 2;
}

- (void)increaseArgumentBarByHeight:(CGFloat)height {
    self.frame = CPRectIncreaseHeight(self.frame, height);
}

- (id<CPValue>)calculateResult {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
