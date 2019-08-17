//
//  CPHeadingCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPHeadingCommand.h"

#import "CPDrawContext.h"

@implementation CPHeadingCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGPoint currentPosition = drawContext.position;
    if (!CGPointEqualToPoint(currentPosition, self.target)) {
        double y = currentPosition.y - self.target.y;
        double x = self.target.x - currentPosition.x;
        double angle = atan2(x, y) * 180.0 / M_PI;
        if (angle < 0) {
            angle += 360.0;
        }
        drawContext.angle = angle;
    }
}

@end
