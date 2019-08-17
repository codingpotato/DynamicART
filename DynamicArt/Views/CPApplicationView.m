//
//  CPApplicationView.m
//  DynamicArt
//
//  Created by Yongwu Wang on 6/18/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPApplicationView.h"

@interface CPApplicationView ()

@property (weak, nonatomic) id<CPApplicationViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CPApplicationView

#pragma mark - property methods

- (void)setType:(CPApplicationViewType)type {
    _type = type;
    if (_type == CPApplicationViewTypeNone) {
        if (self.mainView.superview) {
            [self.mainView removeFromSuperview];
        }
    } else {
        if (!self.mainView.superview) {
            [self addSubview:self.mainView];
        }
    }
}

- (NSString *)appName {
    return self.nameLabel.text;
}

- (void)setAppName:(NSString *)appName {
    self.nameLabel.text = appName;
}

#pragma mark -

- (id)initAtOrigin:(CGPoint)origin delegate:(id<CPApplicationViewDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
        self.frame = CGRectMake(origin.x, origin.y, self.mainView.bounds.size.width, self.mainView.bounds.size.height);
        self.layer.cornerRadius = 10.0;
        self.clipsToBounds = YES;
        
        self.removeButton.layer.shadowColor = [UIColor blackColor].CGColor;
        self.removeButton.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.removeButton.layer.shadowOpacity = 0.8;
    }
    return self;
}

- (void)showRemoveButton {
    self.imageButton.enabled = NO;
    self.removeButton.hidden = NO;
}

- (void)hideRemoveButton {
    self.imageButton.enabled = YES;
    self.removeButton.hidden = YES;
}

- (IBAction)applicationViewTapped:(id)sender {
    [self.delegate applicationViewTapped:self];
}

- (IBAction)removeButtonPressed:(id)sender {
    [self.delegate applicationViewRequestRemove:self];
}

@end
