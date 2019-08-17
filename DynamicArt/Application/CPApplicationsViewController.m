//
//  CPApplicationManagerViewController.m
//  DynamicArt
//
//  Created by wangyw on 8/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPApplicationsViewController.h"

#import "CPApplicationController.h"
#import "CPApplicationsHelpManager.h"
#import "CPPopoverManager.h"

@interface CPApplicationsViewController ()

@property (strong, nonatomic) NSArray *appNames;

@property (strong, nonatomic) NSString *appNameForConfirmedAction;

@property (strong, nonatomic) CPApplicationsHelpManager *applicationsHelpManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIToolbar *rightToolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *duplicateBarButtonItem;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation CPApplicationsViewController

static const NSUInteger numberOfApplicationsInOneCell = 4;

- (NSArray *)appNames {
    if (!_appNames) {
        _appNames = [CPApplicationController defaultController].appNames;
    }
    return _appNames;
}

- (CPApplicationsHelpManager *)applicationsHelpManager {
    if (!_applicationsHelpManager) {
        _applicationsHelpManager = [[CPApplicationsHelpManager alloc] init];
    }
    return _applicationsHelpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItems = self.rightToolbar.items;
    
    if (![CPApplicationController defaultController].count) {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.applicationsHelpManager.helpView.frame = self.tableView.bounds;
        [self.tableView addSubview:self.applicationsHelpManager.helpView];
    }
}

- (IBAction)addApplication:(id)sender {
    NSString *appName = self.searchBar.text;
    if (appName && ![appName isEqualToString:@""]) {
        CPApplicationController *applicationController = [CPApplicationController defaultController];
        if ([applicationController hasApp:appName]) {
            self.appNameForConfirmedAction = appName;
            NSString *actionSheetTitle = [[NSString alloc] initWithFormat:@"Block board \"%@\" exists, override it?", appName];
            UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:actionSheetTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Override" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CPApplicationController defaultController] createNewApp:self.appNameForConfirmedAction];
                [[CPPopoverManager defaultPopoverManager] dismissCurrentPopoverAnimated:YES];
            }]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:actionSheet animated:YES completion:nil];
        } else {
            [applicationController createNewApp:appName];
            [[CPPopoverManager defaultPopoverManager] dismissCurrentPopoverAnimated:YES];
        }
    }
}

- (IBAction)duplicateButtonPressed:(id)sender {
    NSString *appName = self.searchBar.text;
    if (appName && ![appName isEqualToString:@""]) {
        CPApplicationController *applicationController = [CPApplicationController defaultController];
        if ([applicationController hasApp:appName]) {
            self.appNameForConfirmedAction = appName;
            NSString *actionSheetTitle = [[NSString alloc] initWithFormat:@"Block board \"%@\" exists, override it?", appName];
            UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:actionSheetTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Override" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CPApplicationController defaultController] duplicateCurrentAppTo:self.appNameForConfirmedAction];
                [[CPPopoverManager defaultPopoverManager] dismissCurrentPopoverAnimated:YES];
            }]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:actionSheet animated:YES completion:nil];
        } else {
            [applicationController duplicateCurrentAppTo:appName];
            [[CPPopoverManager defaultPopoverManager] dismissCurrentPopoverAnimated:YES];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:NO];
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        for (NSUInteger index = 0; index < numberOfApplicationsInOneCell; index++) {
            CPApplicationView *applicationView = [cell.contentView.subviews objectAtIndex:index];
            if (applicationView.type != CPApplicationViewTypeNone) {
                if (editing) {
                    [applicationView showRemoveButton];
                } else {
                    [applicationView hideRemoveButton];
                }
            }
        }
    }
}

#pragma mark - CPApplicationViewDelegate implement

- (void)applicationViewTapped:(CPApplicationView *)applicationView {
    [[CPApplicationController defaultController] loadApp:applicationView.appName];
    [[CPPopoverManager defaultPopoverManager] dismissCurrentPopoverAnimated:YES];
}

- (void)applicationViewRequestRemove:(CPApplicationView *)applicationView {
    self.appNameForConfirmedAction = applicationView.appName;
    NSString *actionSheetTitle = [[NSString alloc] initWithFormat:@"Delete block board \"%@\"?", applicationView.appName];
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:actionSheetTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[CPApplicationController defaultController] removeApp:self.appNameForConfirmedAction];
        if (![CPApplicationController defaultController].count) {
            [self setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem.enabled = NO;
            self.applicationsHelpManager.helpView.frame = self.tableView.bounds;
            [self.tableView addSubview:self.applicationsHelpManager.helpView];
        }
        [self filterApplicationByString:self.searchBar.text];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate implement

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterApplicationByString:searchBar.text];
}

#pragma mark - Table view data source implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.appNames.count;
    count = (count + numberOfApplicationsInOneCell - 1) / numberOfApplicationsInOneCell;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CPApplicationCell";
    static const CGFloat width = 160.0, seperator = 10.0;
    static const CGFloat cellWidth =  width * numberOfApplicationsInOneCell + seperator * (numberOfApplicationsInOneCell + 1);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bounds = CGRectMake(0.0, 0.0, cellWidth, self.tableView.rowHeight);
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        for (int i = 0; i < numberOfApplicationsInOneCell; i++) {
            CGPoint origin = CGPointMake((width + seperator) * i + seperator, seperator);
            CPApplicationView *applicationView = [[CPApplicationView alloc] initAtOrigin:origin delegate:self];
            [cell.contentView addSubview:applicationView];
        }
    }
    for (NSUInteger index = 0; index < numberOfApplicationsInOneCell; index++) {
        CPApplicationView *applicationView = [cell.contentView.subviews objectAtIndex:index];
        NSUInteger absoluteIndex = index + indexPath.row * numberOfApplicationsInOneCell;
        if (absoluteIndex < self.appNames.count) {
            applicationView.type = CPApplicationViewTypeApp;
            applicationView.appName = [self.appNames objectAtIndex:absoluteIndex];
            if (self.editing) {
                [applicationView showRemoveButton];
            } else {
                [applicationView hideRemoveButton];
            }
            UIImage *thumbnail = [[CPApplicationController defaultController] thumbnailOfApp:applicationView.appName];
            if (!thumbnail) {
                thumbnail = [UIImage imageNamed:@"application_bg.png"];
            }
            [applicationView.imageButton setImage:thumbnail forState:UIControlStateNormal];
        } else {
            applicationView.type = CPApplicationViewTypeNone;
        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - private methods

- (void)filterApplicationByString:(NSString *)string {
    // reset appNames to force reload from application controller
    self.appNames = nil;
    
    if (!string || [string isEqualToString:@""]) {
        self.addBarButtonItem.enabled = NO;
        self.duplicateBarButtonItem.enabled = NO;
    } else {        
        self.addBarButtonItem.enabled = YES;
        self.duplicateBarButtonItem.enabled = [CPApplicationController defaultController].blockController != nil;

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", string];
        self.appNames = [self.appNames filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

@end
