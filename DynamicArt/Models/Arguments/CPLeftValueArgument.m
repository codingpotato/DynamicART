//
//  CPArgumentLeftValue.m
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPLeftValueArgument.h"

#import "CPBlock.h"
#import "CPBlockController.h"
#import "CPVariableManager.h"

@implementation CPLeftValueArgument

static NSString *_encodingKeyVariableName = @"VariableName";

#pragma mark - lifecycle methods

- (id)initWithValue:(id<CPValue>)value {
    self = [super init];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _variableName = [aDecoder decodeObjectForKey:_encodingKeyVariableName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.variableName forKey:_encodingKeyVariableName];
}

- (void)didAddIntoParentBlock {
    if (!self.variableName || [self.variableName isEqualToString:@""]) {
        self.variableName = self.variableManager.lastUsedUserValueVariableName;
    }
    [self.variableManager retainValueVariableByName:self.variableName];
    [super didAddIntoParentBlock];
}

- (void)didRemoveFromParentBlock {
    if (self.variableName) {
        [self.variableManager releaseValueVariableByName:self.variableName];
    }
    [super didRemoveFromParentBlock];
}

#pragma mark -

- (void)updateVariableName:(NSString *)variableName {
    if (self.variableName) {
        [self.variableManager releaseValueVariableByName:self.variableName];
        }
    self.variableName = variableName;
    if (self.variableName) {
        [self.variableManager retainValueVariableByName:self.variableName];
    }
    [self autoResizeByNotifyParentBlock:YES];
}

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock {
    [self resizeForString:self.variableName byNotifyParentBlock:notifyParentBlock];
}

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:@"@"];
    [string appendString:self.variableName];
    [string appendString:@"@"];
}

@end
