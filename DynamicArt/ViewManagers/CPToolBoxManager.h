//
//  CPToolBoxManager.h
//  DynamicArt
//
//  Created by Yongwu Wang on 6/24/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"

@class CPToolBoxManager;

@protocol CPToolBoxManagerDelegate

- (UIImage *)toolBoxManager:(CPToolBoxManager *)toolBoxManager generateImageForBlockClass:(Class)blockClass;

- (void)toolBoxManager:(CPToolBoxManager *)toolBoxManager beginDragThumbnailView:(UIView *)view ofBlockClass:(Class)blockClass;

- (void)toolBoxManager:(CPToolBoxManager *)toolBoxManager moveBlockViewFromLocation:(CGPoint)location inView:(UIView *)view ByTranslation:(CGPoint)translation;

- (void)putDownBlockViewFromToolBoxManager:(CPToolBoxManager *)toolBoxManager;

- (void)dismissToolBoxManager:(CPToolBoxManager *)toolBoxManager;

@end

@interface CPToolBoxManager : NSObject <CPCacheItem, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UISegmentedControl *blockCategoriesSegmentedControl;

@property (weak, nonatomic) IBOutlet UIView *toolBoxView;

- (id)initWithFrame:(CGRect)frame delegate:(id<CPToolBoxManagerDelegate>)delegate;

- (IBAction)dismissToolBoxManager:(id)sender;

- (IBAction)blockCategoryChanged:(id)sender;

- (IBAction)tapMask:(id)sender;

@end
