//
//  CPExpressionView.m
//  DynamicArt
//
//  Created by wangyw on 4/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPExpressionView.h"

#import "CPBlock.h"
#import "CPBlockConfiguration.h"

@interface CPExpressionView ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CPExpressionView

#pragma mark - property methods

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.block.configuration.expressionImage];
        [self insertSubview:_imageView atIndex:0];
    }
    return _imageView;
}

- (id)initWithBlock:(CPBlock *)block delegate:(id<CPBlockViewDelegate>)delegatge {
    self = [super initWithBlock:block delegate:delegatge];
    if (self) {
        [self adjustFrame];
    }
    return self;
}

- (CGFloat)scale {
    return self.imageView.image.scale;
}

- (void)adjustFrame {
    [super adjustFrame];
    self.imageView.frame = self.bounds;
}

@end
