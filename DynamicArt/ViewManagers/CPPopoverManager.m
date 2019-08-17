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

@interface CPPopoverManager ()

@property (weak, nonatomic) id<CPPopoverManagerDelegate> delegate;

@property (strong, nonatomic) UIPopoverController *popoverController;

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

- (void)presentAutoCompleteViewConrollerfromRect:(CGRect)frame inView:(UIView *)view delegate:(id<CPPopoverManagerDelegate>)delegate {
    [self dismissCurrentPopoverAnimated:YES];
    
    self.delegate = delegate;
    self.autoCompleteViewController = [[CPAutoCompleteViewController alloc] init];
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.autoCompleteViewController];
    self.popoverController.passthroughViews = [[NSArray alloc] initWithObjects:view, nil];
    self.popoverController.delegate = self;
    [self.popoverController presentPopoverFromRect:frame inView:view permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown | UIPopoverArrowDirectionRight animated:YES];
}

- (void)reloadDataOfAutoCompleteViewController {
    if (self.autoCompleteViewController) {
        [self.autoCompleteViewController.tableView reloadData];
    }
}

- (void)dismissCurrentPopoverAnimated:(BOOL)animated {
    if (self.popoverController) {
        if (self.autoCompleteViewController) {
            self.autoCompleteViewController = nil;
            [[CPInputFieldManager defaultInputFieldManager] autoCompleteViewDismissed];
        }
        [self.popoverController dismissPopoverAnimated:animated];
        [self.delegate popoverDismissedFromPopoverManager];
        self.popoverController = nil;
        self.delegate = nil;
    }
}

- (void)preparePopoverSegue:(UIStoryboardPopoverSegue *)popoverSegue delegate:(id<CPPopoverManagerDelegate>)delegate {
    [self dismissCurrentPopoverAnimated:YES];
    
    self.delegate = delegate;
    self.popoverController = popoverSegue.popoverController;
    self.popoverController.delegate = self;
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    if (!_defaultPopoverManager.popoverController) {
        _defaultPopoverManager = nil;
    }
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (self.autoCompleteViewController) {
        [[CPInputFieldManager defaultInputFieldManager] autoCompleteViewDismissed];
        self.autoCompleteViewController = nil;
    }
    [self.delegate popoverDismissedFromPopoverManager];
    self.popoverController = nil;
    self.delegate = nil;
}

@end
