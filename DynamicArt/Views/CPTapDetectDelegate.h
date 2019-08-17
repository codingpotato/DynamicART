//
//  CPTapDetectDelegate.h
//  DynamicArt
//
//  Created by wangyw on 7/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPTapDetectDelegate <NSObject>

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;

@end
