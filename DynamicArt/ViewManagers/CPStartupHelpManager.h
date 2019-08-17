//
//  CPStartupHelpmanager.h
//  DynamicArt
//
//  Created by wangyw on 10/2/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPStartupHelpManager;

@protocol CPStartupHelpManagerDelegate <NSObject>

- (BOOL)isToolbarHiddenFromStartupHelpManager:(CPStartupHelpManager *)startupHelpManager;

- (void)toggleToolbarFromStartupHelpManager:(CPStartupHelpManager *)startupHelpManager;

@end

@interface CPStartupHelpManager : NSObject

@property (strong, nonatomic) IBOutlet UIView *view;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *toolbarHelpViewCollection;

- (id)initWithFrame:(CGRect)frame delegate:(id<CPStartupHelpManagerDelegate>)delegate;

- (IBAction)doubleTapMask:(id)sender;

@end
