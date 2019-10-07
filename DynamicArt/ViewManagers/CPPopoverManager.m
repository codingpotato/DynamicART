//
//  CPPopoverManager.m
//  DynamicArt
//
//  Created by wangyw on 10/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPopoverManager.h"

#import "CPAutoCompleteViewController.h"
#import "CPInputField.h"
#import "CPInputFieldManager.h"

@interface CPPopoverManager () <UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) CPAutoCompleteViewController *autoCompleteViewController;

@end

@implementation CPPopoverManager

static CPPopoverManager *_defaultPopoverManager;

+ (CPPopoverManager *)defaultPopoverManager {
    if (!_defaultPopoverManager) {
        _defaultPopoverManager = [[CPPopoverManager alloc] init];
    }
    return _defaultPopoverManager;
}

- (void)presentAutoCompleteViewConrollerfromViewController:(UIViewController*)vc rect:(CGRect)rect inView:(UIView *)view {
    [self dismissCurrentPopoverAnimated:YES];
    
    self.autoCompleteViewController = [[CPAutoCompleteViewController alloc] init];
    self.autoCompleteViewController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController* popoverController = self.autoCompleteViewController.popoverPresentationController;
    popoverController.delegate = self;
    popoverController.sourceView = view;
    popoverController.sourceRect = rect;
    popoverController.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown | UIPopoverArrowDirectionRight;
    [vc presentViewController:self.autoCompleteViewController animated:YES completion:nil];
}

- (void)reloadDataOfAutoCompleteViewController {
    if (self.autoCompleteViewController) {
        [self.autoCompleteViewController.tableView reloadData];
    }
}

- (void)dismissCurrentPopoverAnimated:(BOOL)animated {
    if (self.autoCompleteViewController) {
        [self.autoCompleteViewController.presentingViewController dismissViewControllerAnimated:self.autoCompleteViewController completion:nil];
        self.autoCompleteViewController = nil;
        [[CPInputFieldManager defaultInputFieldManager] autoCompleteViewDismissed];
    }
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    _defaultPopoverManager = nil;
}

#pragma mark - UIPopoverPresentationControllerDelegate implement

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    [[CPInputFieldManager defaultInputFieldManager] autoCompleteViewDismissed];
    self.autoCompleteViewController = nil;
}

@end
