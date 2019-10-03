//
//  CPTitleButton.m
//  DynamicArt
//
//  Created by wangyw on 9/17/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPTitleButton.h"

#import "CPGeometryHelper.h"

@interface CPTitleButton ()

@property (nonatomic) BOOL isArrowUp;

@end

@implementation CPTitleButton

- (void)arrowUp {
    if (!self.isArrowUp) {
        [self setImage:[UIImage imageNamed:@"title_up.png"] forState:UIControlStateNormal];
        self.isArrowUp = YES;
    }
}

- (void)arrowDown {
    if (self.isArrowUp) {
        [self setImage:[UIImage imageNamed:@"title_down.png"] forState:UIControlStateNormal];
        self.isArrowUp = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.center = CPRectCenter(self.bounds);
    self.imageView.frame = CPRectMoveOriginXTo(self.imageView.frame, self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5.0);
}

@end
