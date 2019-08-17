//
//  CPRightValueWeakTypeArgument.m
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRightValueWeakTypeArgument.h"

#import "CPBlock.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPColorValue.h"
#import "CPVariableManager.h"

@implementation CPRightValueWeakTypeArgument

static NSString *_encodingKeyValue = @"Value";
static NSString *_encodingKeyVariableName = @"VariableName";

#pragma mark - property methods

- (CGFloat)verticalSpace {
    return 24.0;
}

#pragma mark - init methods

- (id)initWithValue:(id<CPValue>)value {
    self = [super init];
    if (self) {
        NSAssert(value, @"");
        _value = value;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _value = [aDecoder decodeObjectForKey:_encodingKeyValue];
        _variableName = [aDecoder decodeObjectForKey:_encodingKeyVariableName];
        NSAssert(!_value || !_variableName, @"only one of value and variableName should be valid");
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    NSAssert(!_value || !_variableName, @"only one of value and variableName should be valid");
    [aCoder encodeObject:self.value forKey:_encodingKeyValue];
    [aCoder encodeObject:self.variableName forKey:_encodingKeyVariableName];
}

- (void)didAddIntoParentBlock {
    if (!self.value) {
        if (!self.variableName || [self.variableName isEqualToString:@""]) {
            self.variableName = self.variableManager.lastUsedUserValueVariableName;
        }
        [self.variableManager retainValueVariableByName:self.variableName];
    }
    [super didAddIntoParentBlock];
}

- (void)didRemoveFromParentBlock {
    NSAssert(!_value || !_variableName, @"only one of value and variableName should be valid");
    if (self.variableName) {
        [self.variableManager releaseValueVariableByName:self.variableName];
    }
    [super didRemoveFromParentBlock];
}

#pragma mark - property methods

- (id<CPValue>)value {
    return _value;
}

- (NSString *)variableName {
    return _variableName;
}

- (void)updateValue:(id<CPValue>)value {
    if (self.variableName) {
        [self.variableManager releaseValueVariableByName:self.variableName];
        self.variableName = nil;
    }
    _value = value;
    [self autoResizeByNotifyParentBlock:YES];
}

- (void)updateVariableName:(NSString *)variableName {
    _value = nil;
    if (self.variableName) {
        [self.variableManager releaseValueVariableByName:self.variableName];
    }
    self.variableName = variableName;
    if (!self.variableName || [self.variableName isEqualToString:@""]) {
        self.variableName = self.variableManager.lastUsedUserValueVariableName;
    }
    [self.variableManager retainValueVariableByName:self.variableName];
    [self autoResizeByNotifyParentBlock:YES];
}

- (id<CPValue>)calculateResult {
    NSAssert(!_value || !_variableName, @"only one of value and variableName should be valid");
    id<CPValue> result = [self calculateExpressionResult];
    if (result) {
        return result;
    } else if (self.variableName) {
        return [self.variableManager valueOfVariable:_variableName];
    } else if (self.value) {
        return self.value;
    } else {
        NSAssert(NO, @"");
        return nil;
    }
}

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock {
    if (!self.isHidden) {
        NSAssert(!_value || !_variableName, @"only one of value and variableName should be valid");
        if ([self.value isKindOfClass:[CPColorValue class]]) {
            [self setSize:CGSizeMake(30.0, (self.blockConfiguration.heightOfPlugImage + self.blockConfiguration.heightOfSocketImage) / 2) notifyParentBlock:notifyParentBlock];
        } else {
            [self resizeForString:self.variableName ? self.variableName : self.value.stringValue byNotifyParentBlock:notifyParentBlock];
        }
    }
}

- (BOOL)canConnectToExpression:(CPExpression *)expression {
    return YES;
}

- (void)exportConstantToString:(NSMutableString *)string {
    NSAssert(!_value || !_variableName, @"only one of value and variableName should be valid");
    if (self.variableName) {
        [string appendString:@"$"];
        [string appendString:self.variableName];
        [string appendString:@"$"];
    } else if (self.value) {
        unichar headTag = self.value.headTag;
        if (headTag) {
            [string appendFormat:@"%c", self.value.headTag];
        }
        [string appendString:self.value.stringValue];
        unichar tailTag = self.value.tailTag;
        if (tailTag) {
            [string appendFormat:@"%c", self.value.tailTag];
        }
    } else {
        NSAssert(NO, @"");
    }
}

@end
