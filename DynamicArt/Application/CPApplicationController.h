//
//  CPApplicationController.h
//  DynamicArt
//
//  Created by wangyw on 4/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPBlockController;

extern NSString *CPApplicationControllerKeyPathBlockController;

@interface CPApplicationController : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) CPBlockController *blockController;

@property (nonatomic) BOOL isLoadingFromUrl;

+ (CPApplicationController *)defaultController;

+ (void)loadAppFromUrl:(NSURL *)url;

+ (BOOL)observerAdded;

+ (void)setObserverAdded:(BOOL)observerAdded;

+ (void)releaseDefaultController;

- (id)initWithUrl:(NSURL *)url;

- (NSUInteger)count;

- (NSArray *)appNames;

- (BOOL)hasApp:(NSString *)appName;

- (void)saveCurrentApp;

- (void)createNewApp:(NSString *)appName;

- (void)duplicateCurrentAppTo:(NSString *)appName;

- (void)loadApp:(NSString *)appName;

- (void)removeApp:(NSString *)appName;

- (void)saveThumbnailForCurrentApp:(UIImage *)thumbnailImage;

- (UIImage *)thumbnailOfCurrrentApp;

- (UIImage *)thumbnailOfApp:(NSString *)appName;

- (void)loadAppFromUrl:(NSURL *)url;

@end
