//
//  CPAppStoreReviewManager.m
//  DynamicArtLite
//
//  Created by Wang Yongwu on 2019/10/19.
//  Copyright © 2019 codingpotato. All rights reserved.
//

#import "CPAppStoreReviewManager.h"

#import <StoreKit/StoreKit.h>

@implementation CPAppStoreReviewManager

static NSString * const kReviewWorthyActionCountKey = @"ReviewWorthyActionCount";
static NSString * const kLastReviewRequestAppVersionKey = @"LastReviewRequestAppVersion";
static NSInteger minimumReviewWorthyActionCount = 10;

+ (void)requestReviewIfAppropriate {
    NSInteger actionCount = [NSUserDefaults.standardUserDefaults integerForKey:kReviewWorthyActionCountKey];
    actionCount += 1;
    [NSUserDefaults.standardUserDefaults setInteger:actionCount forKey:kReviewWorthyActionCountKey];
    if (actionCount >= minimumReviewWorthyActionCount) {
        NSString* currentVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        NSString* lastVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:kLastReviewRequestAppVersionKey];
        if (![lastVersion isEqualToString:currentVersion]) {
            [SKStoreReviewController requestReview];
            [NSUserDefaults.standardUserDefaults setInteger:0 forKey:kReviewWorthyActionCountKey];
            [NSUserDefaults.standardUserDefaults setObject:currentVersion forKey:kLastReviewRequestAppVersionKey];
        }
    }
}

@end
