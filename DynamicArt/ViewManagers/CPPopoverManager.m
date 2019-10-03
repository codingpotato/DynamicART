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

- (void)presentAutoCompleteViewConrollerfromViewController:(UIViewController*)vc rect:(CGRect)rect inView:(UIView *)view delegate:(id<CPPopoverManagerDelegate>)delegate {
    [self dismissCurrentPopoverAnimated:YES];
    
    self.delegate = delegate;
    self.autoCompleteViewController = [[CPAutoCompleteViewController alloc] init];
    self.autoCompleteViewController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController* popoverController = self.autoCompleteViewController.popoverPresentationController;
    popoverController.sourceView = view;
    popoverController.sourceRect = rect;
    popoverController.delegate = self;
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
        self.autoCompleteViewController = nil;
        [[CPInputFieldManager defaultInputFieldManager] autoCompleteViewDismissed];
    }
    [self.delegate popoverDismissedFromPopoverManager];
    self.delegate = nil;
}

- (void)preparePopoverSegue:(UIStoryboardSegue *)popoverSegue delegate:(id<CPPopoverManagerDelegate>)delegate {
    [self dismissCurrentPopoverAnimated:YES];
    self.delegate = delegate;
}

#pragma mark - CPCacheItem implement

+ (void)releaseCache {
    /*if (!_defaultPopoverManager.popoverController) {
        _defaultPopoverManager = nil;
    }*/
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    if (self.autoCompleteViewController) {
        [[CPInputFieldManager defaultInputFieldManager] autoCompleteViewDismissed];
        self.autoCompleteViewController = nil;
    }
    [self.delegate popoverDismissedFromPopoverManager];
    self.delegate = nil;
}

@end