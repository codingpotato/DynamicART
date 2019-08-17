//
//  CPHelpViewController.h
//  DynamicArt
//
//  Created by wangyw on 9/15/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPHelpContentViewController.h"

@class CPHelpViewController;

@protocol CPHelpViewControllerDelegate <NSObject>

- (void)backFromHelpViewController:(CPHelpViewController *)helpViewController;

@end

@interface CPHelpViewController : UIViewController <CPHelpContentViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) id<CPHelpViewControllerDelegate> delegate;

- (IBAction)doneButtonPressed:(id)sender;

- (IBAction)helpContentButtonPressed:(id)sender;

@end
