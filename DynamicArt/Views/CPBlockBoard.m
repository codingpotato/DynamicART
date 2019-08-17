//
//  CPBlockBoard.m
//  DynamicArt
//
//  Created by wangyw on 4/28/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlockBoard.h"

#import "CPTapDetectDelegate.h"

@implementation CPBlockBoard

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
	switch (tapCount) {
        case 1:
			[self.tapDetectDelegate view:self singleTapDetected:touch];
			break;
		case 2:
			[self.tapDetectDelegate view:self doubleTapDetected:touch];
			break;
		default:
			break;
	}
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

@end
