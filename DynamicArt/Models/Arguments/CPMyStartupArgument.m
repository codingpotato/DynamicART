//
//  CPMyStartupArgument.m
//  DynamicArt
//
//  Created by wangyw on 10/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMyStartupArgument.h"

#import "CPMyStartup.h"
#import "CPMyStartupManager.h"

@implementation CPMyStartupArgument

static NSString *_encodingKeyStartupName = @"StartupName";

#pragma mark - lifecycle methods

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
    [self.myStartupManager addMyStartup:(CPMyStartup *)self.parentBlock];
    [super didAddIntoParentBlock];
}

- (void)didRemoveFromParentBlock {
    [self.myStartupManager removeMyStartup:(CPMyStartup *)self.parentBlock];
    [super didRemoveFromParentBlock];
}

#pragma mark -

- (void)updateStartupName:(NSString *)startupName {
    NSAssert([self.parentBlock isKindOfClass:[CPMyStartup class]], @"");
    
    [self.myStartupManager removeMyStartup:(CPMyStartup *)self.parentBlock];
    self.startupName = startupName;
    if (!self.startupName || [self.startupName isEqualToString:@""]) {
        self.startupName = self.myStartupManager.lastUsedStartupName;
    }
    [self.myStartupManager addMyStartup:(CPMyStartup *)self.parentBlock];
    [self autoResizeByNotifyParentBlock:YES];
}

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock {
    [self resizeForString:self.startupName byNotifyParentBlock:notifyParentBlock];
}

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:self.startupName];
}

@end
