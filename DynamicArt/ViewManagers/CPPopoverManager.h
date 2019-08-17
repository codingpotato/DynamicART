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

@interface CPPopoverManager : NSObject <CPCacheItem, UIPopoverControllerDelegate>

+ (CPPopoverManager *)defaultPopoverManager;

- (void)presentAutoCompleteViewConrollerfromRect:(CGRect)frame inView:(UIView *)view delegate:(id<CPPopoverManagerDelegate>)delegate;

- (void)reloadDataOfAutoCompleteViewController;

- (void)dismissCurrentPopoverAnimated:(BOOL)animated;

- (void)preparePopoverSegue:(UIStoryboardPopoverSegue *)popoverSegue delegate:(id<CPPopoverManagerDelegate>)delegate;

@end
