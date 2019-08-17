//
//  CPStageViewController.h
//  DynamicArt
//
//  Created by wangyw on 4/29/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPDrawContext.h"
#import "CPFullScreenViewController.h"
#import "CPPopoverManager.h"
#import "CPStageView.h"
#import "CPSynthesizer.h"

@class CPStageViewController;

@protocol CPStageViewControllerDelegate <NSObject>

- (void)dismissStageViewController:(CPStageViewController *)stageViewController animated:(BOOL)animated;

@end

@interface CPStageViewController : CPFullScreenViewController <CPDrawContext, CPPopoverManagerDelegate, CPStageViewDelegate, CPSynthesizerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) id<CPStageViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet CPStageView *stage;

@property (weak, nonatomic) IBOutlet UIImageView *turtleImageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionBarButtonItem;

- (IBAction)backBarButtonPressed:(id)sender;

- (IBAction)actionBarButtonPressed:(id)sender;

-(IBAction)logBarButtonPressed:(id)sender;

@end
