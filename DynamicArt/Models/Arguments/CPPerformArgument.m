//
//  CPMyStartupPerformArgument.m
//  DynamicArt
//
//  Created by wangyw on 10/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPerformArgument.h"

#import "CPMyStartupArgument.h"
#import "CPMyStartupManager.h"
#import "CPValue.h"

@implementation CPPerformArgument

static NSString *_encodingKeyStartupName = @"StartupName";

#pragma mark - init methods

- (id)initWithValue:(id<CPValue>)value {
    self = [super init];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _startupName = [aDecoder decodeObjectForKey:_encodingKeyStartupName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.startupName forKey:_encodingKeyStartupName];
}

- (void)didAddIntoParentBlock {
    if (!self.startupName || [self.startupName isEqualToString:@""]) {
        self.startupName = self.myStartupManager.lastUsedStartupName;
    }
    [super didAddIntoParentBlock];
}

- (void)updateStartupName:(NSString *)startupName {
    self.startupName = startupName;
    if (!self.startupName || [self.startupName isEqualToString:@""]) {
        self.startupName = self.myStartupManager.lastUsedStartupName;
    }
    [self autoResizeByNotifyParentBlock:YES];
}

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock {
    [self resizeForString:self.startupName byNotifyParentBlock:notifyParentBlock];
}

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:@"("];
    [string appendString:self.startupName];
    [string appendString:@")"];
}

@end
