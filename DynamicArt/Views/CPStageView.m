//
//  CPStageView.m
//  DynamicArt
//
//  Created by wangyw on 4/26/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPStageView.h"

#import "CPTapDetectDelegate.h"

@implementation CPStageView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    [self.delegate stageView:self beginTouchAt:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint previousTouchPoint = [touch previousLocationInView:self];
    [self.delegate stageView:self touchMoveTo:touchPoint from:previousTouchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate stageViewEndTouch:self];

	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
	switch (tapCount) {
		case 2:
			[self.tapDetectDelegate view:self doubleTapDetected:touch];
			break;
		default:
			break;
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate stageViewEndTouch:self];
}

@end
