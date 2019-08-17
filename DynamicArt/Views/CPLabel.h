//
//  CPLabel.h
//  DynamicArt
//
//  Created by wangyw on 10/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPLabel;

@protocol CPLabelDelegate <NSObject>

- (BOOL)labelShouldBeginEditing:(CPLabel *)label;

@end

@interface CPLabel : UILabel

- (id)initWithDelegate:(id<CPLabelDelegate>)delegate;

@end
