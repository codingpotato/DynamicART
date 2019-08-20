//
//  CPPopoverManager.h
//  DynamicArt
//
//  Created by wangyw on 10/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"

@class CPPopoverManager;

@protocol CPPopoverManagerDelegate <NSObject>

- (void)popoverDismissedFromPopoverManager;

@end

@interface CPPopoverManager : NSObject <CPCacheItem, UIPopoverPresentationControllerDelegate>

+ (CPPopoverManager *)defaultPopoverManager;

- (void)presentAutoCompleteViewConrollerfromViewController:(UIViewController*)vc rect:(CGRect)rect inView:(UIView *)view delegate:(id<CPPopoverManagerDelegate>)delegate;

- (void)reloadDataOfAutoCompleteViewController;

- (void)dismissCurrentPopoverAnimated:(BOOL)animated;

- (void)preparePopoverSegue:(UIStoryboardSegue *)popoverSegue delegate:(id<CPPopoverManagerDelegate>)delegate;

@end
