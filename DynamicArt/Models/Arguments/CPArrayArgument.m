//
//  CPArrayArgument.m
//  DynamicArt
//
//  Created by wangyw on 5/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArrayArgument.h"

#import "CPBlock.h"
#import "CPBlockController.h"
#import "CPVariableManager.h"

@implementation CPArrayArgument

static NSString *_encodingKeyArrayName = @"ArrayName";

#pragma mark - lifecycle methods

- (id)initWithValue:(id<CPValue>)value {
    self = [super init];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _arrayName = [aDecoder decodeObjectForKey:_encodingKeyArrayName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.arrayName forKey:_encodingKeyArrayName];
}

- (void)didAddIntoParentBlock {
    if (!self.arrayName || [self.arrayName isEqualToString:@""]) {
        self.arrayName = self.variableManager.lastUsedUserArrayVariableName;
    }
    [self.variableManager retainArrayVariableByName:self.arrayName];
    [super didAddIntoParentBlock];
}

- (void)didRemoveFromParentBlock {
    if (self.arrayName) {
        [self.variableManager releaseArrayVariableByName:self.arrayName];
    }
    [super didRemoveFromParentBlock];
}

#pragma mark -

- (void)updateArrayName:(NSString *)arrayName {
    if (self.arrayName) {
        [self.variableManager releaseArrayVariableByName:self.arrayName];
    }
    self.arrayName = arrayName;
    if (!self.arrayName || [self.arrayName isEqualToString:@""]) {
        self.arrayName = self.variableManager.lastUsedUserArrayVariableName;
    }
    [self.variableManager retainArrayVariableByName:self.arrayName];
    [self autoResizeByNotifyParentBlock:YES];
}

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock {
    [self resizeForString:self.arrayName byNotifyParentBlock:notifyParentBlock];
}

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:@"{"];
    [string appendString:self.arrayName];
    [string appendString:@"}"];
}

@end
