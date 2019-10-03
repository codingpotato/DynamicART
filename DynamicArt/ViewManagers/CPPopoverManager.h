//
//  CPPopoverManager.h
//  DynamicArt
//
//  Created by wangyw on 10/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"

@interface CPPopoverManager : NSObject <CPCacheItem>

+ (CPPopoverManager *)defaultPopoverManager;

- (void)presentAutoCompleteViewConrollerfromViewController:(UIViewController*)vc rect:(CGRect)rect inView:(UIView *)view;

- (void)reloadDataOfAutoCompleteViewController;

- (void)dismissCurrentPopoverAnimated:(BOOL)animated;

@end
