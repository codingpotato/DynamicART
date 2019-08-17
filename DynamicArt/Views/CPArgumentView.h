//
//  CPArgumentView.h
//  Polymer
//
//  Created by wangyw on 12-2-25.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLabel.h"

@class CPArgument;
@class CPInputField;

@protocol CPArgumentView <NSObject>

- (id)initWithArgument:(CPArgument *)argument;

- (void)adjustFrame;

- (void)removeObservers;

- (void)inputFieldWillEndEditing:(CPInputField *)inputField;

@end

@interface CPArgumentView : UIImageView <CPArgumentView, CPLabelDelegate>

@property (weak, nonatomic, readonly) CPArgument *argument;

@property (strong, nonatomic) CPLabel *textLabel;

- (void)inputTypeChangedTo:(int)index;

@end
