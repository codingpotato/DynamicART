//
//  CPMainViewController.h
//  DynamicArt
//
//  Created by wangyw on 8/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlockViewDelegate.h"
#import "CPFullScreenViewController.h"
#import "CPHelpViewController.h"
#import "CPInputFieldManager.h"
#import "CPPopoverManager.h"
#import "CPStageViewController.h"
#import "CPStartupHelpManager.h"
#import "CPToolBoxManager.h"

@class CPBlockBoard;

@interface CPMainViewController : CPFullScreenViewController < CPBlockViewDelegate, CPHelpViewControllerDelegate, CPInputFieldManagerDelegate, CPPopoverManagerDelegate, CPStageViewControllerDelegate, CPStartupHelpManagerDelegate, CPToolBoxManagerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBoxBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *runBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *alignBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *airDropBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *mailBarButtonItem;

@property (weak, nonatomic) IBOutlet UIImageView *trashImageView;

@property (weak, nonatomic) IBOutlet CPBlockBoard *blockBoard;

- (IBAction)toolBoxBarButtonPressed:(id)sender;

- (IBAction)titleButtonPressed:(id)sender;

- (IBAction)runBarButtonPressed:(id)sender;

- (IBAction)helpBarButtonPressed:(id)sender;

- (IBAction)alignBarButtonPressed:(id)sender;

- (IBAction)airDropBarButtonPressed:(id)sender;

- (IBAction)mailBarButtonPressed:(id)sender;

@end
