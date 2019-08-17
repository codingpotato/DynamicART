//
//  CPStageView.h
//  DynamicArt
//
//  Created by wangyw on 4/26/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPTapDetectDelegate;

@class CPStageView;

@protocol CPStageViewDelegate <NSObject>

- (void)stageView:(CPStageView *)stageView beginTouchAt:(CGPoint)touchPoint;

- (void)stageView:(CPStageView *)stageView touchMoveTo:(CGPoint)touchPoint from:(CGPoint)previousTouchPoint;

- (void)stageViewEndTouch:(CPStageView *)stageView;

@end

@interface CPStageView : UIImageView

@property (weak, nonatomic) IBOutlet id<CPStageViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet id<CPTapDetectDelegate> tapDetectDelegate;

@end
