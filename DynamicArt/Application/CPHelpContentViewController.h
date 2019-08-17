//
//  CPHelpContentViewController.h
//  DynamicArt
//
//  Created by wangyw on 9/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPHelpContentViewController;

@protocol CPHelpContentViewControllerDelegate <NSObject>

- (void)helpContentViewController:(CPHelpContentViewController *)helpContentViewCOntroller sectionTitle:(NSString *)title selectedHtml:(NSString *)htmlPath;

@end

@interface CPHelpContentViewController : UITableViewController

@property (weak, nonatomic) id<CPHelpContentViewControllerDelegate> delegate;

@end
