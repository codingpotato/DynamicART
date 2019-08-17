//
//  CPApplicationsHelpManager.m
//  DynamicArt
//
//  Created by wangyw on 12/19/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPApplicationsHelpManager.h"

@implementation CPApplicationsHelpManager

- (id)init {
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    }
    return self;
}

@end
