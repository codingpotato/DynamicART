//
//  CPProgressViewManager.h
//  DynamicArt
//
//  Created by wangyw on 10/6/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@interface CPProgressViewManager : NSObject

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

+ (void)showProgressViewWithParentView:(UIView *)parentView Message:(NSString *)message;

+ (void)setProgress:(float)progress;

@end
