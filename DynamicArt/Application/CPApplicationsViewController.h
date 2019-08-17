//
//  CPApplicationManagerViewController.h
//  DynamicArt
//
//  Created by wangyw on 8/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPApplicationView.h"

@interface CPApplicationsViewController : UIViewController <CPApplicationViewDelegate, UIActionSheetDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

- (IBAction)addApplication:(id)sender;

- (IBAction)duplicateButtonPressed:(id)sender;

@end
