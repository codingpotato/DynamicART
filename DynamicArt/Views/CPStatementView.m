//
//  CPStatementView.m
//  DynamicArt
//
//  Created by wangyw on 4/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPStatementView.h"

#import "CPBlockConfiguration.h"
#import "CPColorValue.h"
#import "CPHeadStatement.h"

@interface CPStatementView ()

@property (strong, nonatomic) UIImageView *plugImageView;

@property (strong, nonatomic) NSMutableArray *innerSocketImageViews;

@property (strong, nonatomic) UIImageView *socketImageView;

@end

@implementation CPStatementView

#pragma mark - property methods

- (UIImageView *)plugImageView {
    if (!_plugImageView) {
        _plugImageView = [[UIImageView alloc] initWithImage:self.block.configuration.plugImage];
        [self insertSubview:_plugImageView atIndex:0];
    }
    return _plugImageView;
}

- (NSMutableArray *)innerSocketImageViews {
    if (!_innerSocketImageViews) {
        NSAssert(self.block.configuration.numberOfSockets > 1, @"");
        _innerSocketImageViews = [NSMutableArray arrayWithCapacity:self.block.configuration.numberOfSockets - 1];
        for (int index = 0; index < self.block.configuration.numberOfSockets - 1; index++) {
            UIImageView *innerImageView = [[UIImageView alloc] initWithImage:index < self.block.configuration.numberOfSockets - 2 ? self.block.configuration.innerSocketImage : self.block.configuration.innerBottomSocketImage];
            [self insertSubview:innerImageView atIndex:0];
            [_innerSocketImageViews addObject:innerImageView];
        }        
    }
    return _innerSocketImageViews;
}

- (UIImageView *)socketImageView {
    if (!_socketImageView) {
        _socketImageView = [[UIImageView alloc] initWithImage:self.block.configuration.numberOfSockets > 0 ? self.block.configuration.socketImage : self.block.configuration.noSocketImage];
        [self insertSubview:_socketImageView atIndex:0];
    }
    return _socketImageView;
}

- (id)initWithBlock:(CPBlock *)block delegate:(id<CPBlockViewDelegate>)delegatge {
    self = [super initWithBlock:block delegate:delegatge];
    if (self) {
        [self adjustFrame];
    }
    return self;
}

- (CGFloat)scale {
    return self.plugImageView.image.scale;
}

- (void)adjustFrame {
    NSAssert([self.block isKindOfClass:[CPStatement class]], @"");
    
    [super adjustFrame];
    
    CPStatement *statement = (CPStatement *)self.block;
    CGRect frame;
    frame.origin.x = frame.origin.y = 0;
    frame.size.width = self.frame.size.width;
    frame.size.height = statement.configuration.numberOfSockets > 0 ? [statement centerOfSocketAtIndex:0].y - statement.frame.origin.y : statement.frame.size.height;
    frame.size.height -= statement.configuration.heightOfSocketImage;
    self.plugImageView.frame = frame;
        
    for (int index = 0; index < self.block.configuration.numberOfSockets - 1; index++) {
        UIImageView *innerImageView = [self.innerSocketImageViews objectAtIndex:index];
        frame.origin.y += frame.size.height;
        frame.size.height = [statement centerOfSocketAtIndex:index + 1].y - statement.frame.origin.y - frame.origin.y;
        frame.size.height -= statement.configuration.heightOfSocketImage;
        innerImageView.frame = frame;
    }
    
    frame.origin.y += frame.size.height;
    frame.size.height = statement.configuration.heightOfSocketImage;
    self.socketImageView.frame = frame;
}

#pragma mark - UIGestureRecognizerDelegate implement

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:self];
    UIImageView *clickedImageView = nil;
    if (CGRectContainsPoint(self.plugImageView.frame, location)) {
        clickedImageView = self.plugImageView;
    } else if (CGRectContainsPoint(self.socketImageView.frame, location)) {
        clickedImageView = self.socketImageView;
    } else {
        if (self.block.configuration.numberOfSockets > 1) {
            for (UIImageView *imageView in self.innerSocketImageViews) {
                if (CGRectContainsPoint(imageView.frame, location)) {
                    clickedImageView = imageView;
                    break;
                }
            }
        }
    }
    
    if (clickedImageView) {
        CGPoint imageLocation = [self convertPoint:location toView:clickedImageView];
        unsigned char pixel[1] = { 0 };
        CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 1, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
        UIGraphicsPushContext(context);
        [clickedImageView.image drawInRect:CGRectMake(-imageLocation.x, -imageLocation.y, clickedImageView.bounds.size.width, clickedImageView.bounds.size.height)];
        UIGraphicsPopContext();
        CGContextRelease(context);
        CGFloat alpha = pixel[0] / CPColorValueComponentMax;
        return alpha > 0.01;
    } else {
        return YES;
    }
}

@end
