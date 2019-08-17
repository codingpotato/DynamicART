//
//  CPInputField.h
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPArgument;

@interface CPInputField : NSObject <UITextFieldDelegate>

@property (weak, nonatomic) CPArgument *argument;

- (UIView *)view;

- (void)willShow;

- (CGSize)contentSizeOfAutoCompleteView;

- (int)numberOfRowsForAutoCompleteView;

- (void)prepareAutoCompleteViewCell:(UITableViewCell *)cell atIndex:(int)index;

- (void)autoCompleteViewDidSelectRowAtIndex:(int)index;

- (NSArray *)filterArray:(NSArray *)array withPrefix:(NSString *)prefix;

@end
