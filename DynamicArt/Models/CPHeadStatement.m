//
//  CPHeadStatement.m
//  DynamicArt
//
//  Created by wangyw on 4/30/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPHeadStatement.h"

#import "CPBlockController.h"

@implementation CPHeadStatement

- (CGPoint)centerOfPlug {
    [self doesNotRecognizeSelector:_cmd];
    return CGPointZero;
}

- (NSUInteger)findConnectedSocketFromStatement:(CPStatement *)socketStatement {
    return NSNotFound;
}

- (void)execute {
}

@end
