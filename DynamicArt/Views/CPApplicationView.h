//
//  CPApplicationView.h
//  DynamicArt
//
//  Created by Yongwu Wang on 6/18/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

typedef enum {
    CPApplicationViewTypeNone,
    CPApplicationViewTypeApp,
} CPApplicationViewType;

@class CPApplicationView;

@protocol CPApplicationViewDelegate <NSObject>

- (void)applicationViewTapped:(CPApplicationView *)applicationView;

- (void)applicationViewRequestRemove:(CPApplicationView *)applicationView;

@end

@interface CPApplicationView : UIView

@property (nonatomic) CPApplicationViewType type;

@property (nonatomic) NSString *appName;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

- (id)initAtOrigin:(CGPoint)origin delegate:(id<CPApplicationViewDelegate>)delegate;

- (void)showRemoveButton;

- (void)hideRemoveButton;

- (IBAction)applicationViewTapped:(id)sender;

- (IBAction)removeButtonPressed:(id)sender;

@end
