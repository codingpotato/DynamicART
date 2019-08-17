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

@property (nonatomic) BOOL isArrayUp;

@end

@implementation CPTitleButton

- (void)arrawUp {
    if (!self.isArrayUp) {
        [self setImage:[UIImage imageNamed:@"title_up.png"] forState:UIControlStateNormal];
        self.isArrayUp = YES;
    }
}

- (void)arrawDown {
    if (self.isArrayUp) {
        [self setImage:[UIImage imageNamed:@"title_down.png"] forState:UIControlStateNormal];
        self.isArrayUp = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.center = CPRectCenter(self.bounds);
    self.imageView.frame = CPRectMoveOriginXTo(self.imageView.frame, self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5.0);
}

@end
