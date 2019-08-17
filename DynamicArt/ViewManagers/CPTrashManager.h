//
//  CPTrashManager.h
//  DynamicArt
//
//  Created by wangyw on 11/26/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@interface CPTrashManager : NSObject

- (id)initWithTrashView:(UIView *)trashView;

- (void)pickedUpFromBlockView:(UIView *)blockView;

- (void)blockViewMoveIntoTrash:(UIView *)blockView location:(CGPoint)location byTranslation:(CGPoint)translation;

- (void)putDownFromBlockView:(UIView *)blockView;

- (BOOL)isInRemoveState;

@end
