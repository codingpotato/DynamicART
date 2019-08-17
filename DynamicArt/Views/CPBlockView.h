//
//  CPBlockView.h
//  DynamicArt
//
//  Created by wangyw on 4/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPBlockViewDelegate;

@class CPBlock;

@interface CPBlockView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) CPBlock *block;

@property (weak, nonatomic) id<CPBlockViewDelegate> delegate;

- (id)initWithBlock:(CPBlock *)block delegate:(id<CPBlockViewDelegate>)delegatge;

- (CGFloat)scale;

- (void)remove;

- (void)adjustFrame;

@end
