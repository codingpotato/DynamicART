//
//  CPApplicationsViewController.h
//  DynamicArt
//
//  Created by wangyw on 8/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPApplicationView.h"

@class CPApplicationsViewController;

@protocol CPApplicationsViewControllerDelegate

- (void)applicationsViewControllerDismissed:(CPApplicationsViewController*)vc;

@end

@interface CPApplicationsViewController : UIViewController <CPApplicationViewDelegate, UIActionSheetDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<CPApplicationsViewControllerDelegate> delegate;

- (IBAction)addApplication:(id)sender;

- (IBAction)duplicateButtonPressed:(id)sender;

@end
