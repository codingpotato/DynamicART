//
//  CPBlockViewDelegate.h
//  DynamicArt
//
//  Created by wangyw on 4/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPBlockView;

@class CPInputField;

@protocol CPBlockViewDelegate <NSObject>

- (void)pickUpFromBlockView:(CPBlockView *)blockView;

- (void)moveFromBlockView:(CPBlockView *)blockView location:(CGPoint)location byTranslation:(CGPoint)translation;

- (void)putDownFromBlockView:(CPBlockView *)blockView;

- (void)ghostBlockView:(CPBlockView *)blockView;

@end
