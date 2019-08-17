//
//  CPLabel.m
//  DynamicArt
//
//  Created by wangyw on 10/7/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLabel.h"

@interface CPLabel ()

@property (weak, nonatomic) id<CPLabelDelegate> delegate;

@end

@implementation CPLabel

- (id)initWithDelegate:(id<CPLabelDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate labelShouldBeginEditing:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
