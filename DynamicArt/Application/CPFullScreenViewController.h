//
//  CPFullScreenViewController.h
//  DynamicArt
//
//  Created by wangyw on 8/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTapDetectDelegate.h"

@class CPTitleButton;

@interface CPFullScreenViewController : UIViewController

@property (nonatomic) BOOL isToolbarHidden;

@property (weak, nonatomic) IBOutlet CPTitleButton *titleButton;

@property (weak, nonatomic) IBOutlet UIToolbar *topToolbar;

@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

- (void)toggleToolbar;

- (void)showToolbar;

- (void)hideToolbar;

@end
