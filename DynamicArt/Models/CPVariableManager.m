//
//  CPVariableManager.m
//  DynamicArt
//
//  Created by wangyw on 3/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPVariableManager.h"

#import "CPNumberValue.h"
#import "CPStringValue.h"

#pragma mark - CPVariable

@interface CPVariable : NSObject

@property (nonatomic, getter = isBuildin) BOOL buildin;

@property (nonatomic) NSUInteger count;

- (id)initWithBuildin:(BOOL)buildin;

@end

@implementation CPVariable

- (id)initWithBuildin:(BOOL)buildin {
    self = [super init];
    if (self) {
        _buildin = buildin;
        _count = 0;
    }
    return self;
}

@end

#pragma mark - CPValueVariable

@interface CPValueVariable : CPVariable

@property (strong, nonatomic) id<CPValue> value;

@end

@implementation CPValueVariable

- (id<CPValue>)value {
    if (!_value) {
        _value = [CPNumberValue valueWithDouble:0.0];
    }
    return _value;
}

@end

#pragma mark - CPArrayVariable

@interface CPArrayVariable : CPVariable

@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation CPArrayVariable

- (NSMutableArray *)array {
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

@end

#pragma mark - CPVariableManager

@interface CPVariableManager ()

@property (strong, nonatomic) NSMutableDictionary *valueVariables;

@property (strong, nonatomic) NSMutableDictionary *arrayVariables;

@property (nonatomic) dispatch_queue_t serialQueue;

- (NSUInteger)normalizedIndex:(NSInteger)index forLength:(NSUInteger)length;

@end

@implementation CPVariableManager

#pragma mark - property methods

- (NSString *)lastUsedUserValueVariableName {
    static NSString *defaultVariableName = @"dynamic";
    
    if (_useDefaultVariableName || !_lastUsedUserValueVariableName || [_lastUsedUserValueVariableName isEqualToString:@""]) {
        return defaultVariableName;
    } else {
        return _lastUsedUserValueVariableName;
    }
}

- (NSString *)lastUsedUserArrayVariableName {
    static NSString *defaulArrayVariableName = @"list";
    
    if (_useDefaultVariableName || !_lastUsedUserArrayVariableName || [_lastUsedUserArrayVariableName isEqualToString:@""]) {
        return defaulArrayVariableName;
    } else {
        return _lastUsedUserArrayVariableName;
    }
}

- (NSMutableDictionary *)valueVariables {
    if (!_valueVariables) {
        _valueVariables = [NSMutableDictionary dictionary];
    }
    return _valueVariables;
}

- (NSMutableDictionary *)arrayVariables {
    if (!_arrayVariables) {
        _arrayVariables = [NSMutableDictionary dictionary];
    }
    return _arrayVariables;
}

- (dispatch_queue_t)serialQueue {
    if (_serialQueue == NULL) {
        _serialQueue = dispatch_queue_create("codingpotato.variableManagerSerialQueue", NULL);
    }
    return _serialQueue;
}

#pragma mark -

- (void)addBuildinValueVariableByName:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPVariable *variable = [self.valueVariables objectForKey:variableName];
    NSAssert(!variable, @"");
    variable = [[CPValueVariable alloc] initWithBuildin:YES];
    [self.valueVariables setObject:variable forKey:variableName];
}

- (NSArray *)allValueVariableNames {
    return [self.valueVariables.allKeys sortedArrayUsingSelector:@selector(localizedCompare:)];
}

- (NSArray *)allUserValueVariableNames {
    NSSet *variableNames = [self.valueVariables keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return !((CPValueVariable *)obj).isBuildin;
    }];
    return [variableNames.allObjects sortedArrayUsingSelector:@selector(localizedCompare:)];
}

- (NSArray *)allArrayVariableNames {
    return [self.arrayVariables.allKeys sortedArrayUsingSelector:@selector(localizedCompare:)];
}

- (BOOL)containsValueVariable:(NSString *)variableName {
    CPVariable *variable = [self.valueVariables objectForKey:variableName];
    return variable != nil;
}

- (BOOL)containsArrayVariable:(NSString *)variableName {
    CPVariable *variable = [self.arrayVariables objectForKey:variableName];
    return variable != nil;
}

- (void)retainValueVariableByName:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPValueVariable *variable = [self.valueVariables objectForKey:variableName];
    if (variable) {
        variable.count++;
    } else {
        variable = [[CPValueVariable alloc] initWithBuildin:NO];
        variable.count++;
        [self.valueVariables setObject:variable forKey:variableName];
    }
    if (!variable.isBuildin) {
        _lastUsedUserValueVariableName = variableName;
    }
}

- (void)retainArrayVariableByName:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
    if (variable) {
        variable.count++;
    } else {
        variable = [[CPArrayVariable alloc] initWithBuildin:NO];
        variable.count++;
        [self.arrayVariables setObject:variable forKey:variableName];
    }
    if (!variable.isBuildin) {
        _lastUsedUserArrayVariableName = variableName;
    }
}

- (void)releaseValueVariableByName:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPVariable *variable = [self.valueVariables objectForKey:variableName];
    NSAssert(variable, @"");
    
    variable.count--;
    if (!variable.isBuildin && variable.count == 0) {
        [self.valueVariables removeObjectForKey:variableName];
        if ([self.lastUsedUserValueVariableName isEqualToString:variableName]) {
            _lastUsedUserValueVariableName = nil;
        }
    }
}

- (void)releaseArrayVariableByName:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPVariable *variable = [self.arrayVariables objectForKey:variableName];
    NSAssert(variable, @"");
    
    variable.count--;
    if (!variable.isBuildin && variable.count == 0) {
        [self.arrayVariables removeObjectForKey:variableName];
        if ([self.lastUsedUserArrayVariableName isEqualToString:variableName]) {
            _lastUsedUserArrayVariableName = nil;
        }
    }
}

- (NSUInteger)retainCountForValueVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPVariable *variable = [self.valueVariables objectForKey:variableName];
    NSAssert(variable, @"");
    return variable.count;
}

- (NSUInteger)retainCountForArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPVariable *variable = [self.arrayVariables objectForKey:variableName];
    NSAssert(variable, @"");
    return variable.count;
}

- (id<CPValue>)valueOfVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPValueVariable *variable = [self.valueVariables objectForKey:variableName];
    return variable.value;
}

- (void)setValue:(id<CPValue>)value forVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    dispatch_sync(self.serialQueue, ^{
        CPValueVariable *variable = [self.valueVariables objectForKey:variableName];
        variable.value = value;
    });
}

- (NSUInteger)countOfArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    NSUInteger __block count;
    dispatch_sync(self.serialQueue, ^{
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        count = variable.array.count;
    });
    return count;
}

- (id<CPValue>)valueAtIndex:(NSInteger)index ofArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
    NSUInteger count = variable.array.count;
    if (count > 0) {
        return [variable.array objectAtIndex:[self normalizedIndex:index forLength:count]];
    } else {
        return [CPNumberValue valueWithDouble:0.0];
    }
}

- (void)addValue:(id<CPValue>)value inArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    dispatch_sync(self.serialQueue, ^{
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        [variable.array addObject:value];
    });
}

- (void)insertValue:(id<CPValue>)value atIndex:(NSInteger)index inArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    dispatch_sync(self.serialQueue, ^{
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        NSUInteger count = variable.array.count;
        if (count > 0) {
            [variable.array insertObject:variable atIndex:[self normalizedIndex:index forLength:count]];
        } else {
            [variable.array insertObject:variable atIndex:0];
        }
    });
}

- (void)replaceValue:(id<CPValue>)value atIndex:(NSInteger)index inArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    dispatch_sync(self.serialQueue, ^{
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        NSUInteger count = variable.array.count;
        if (count > 0) {
            [variable.array replaceObjectAtIndex:[self normalizedIndex:index forLength:count] withObject:value];
        }
    });
}

- (void)removeValueAtIndex:(NSInteger)index inArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    dispatch_sync(self.serialQueue, ^{
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        NSUInteger count = variable.array.count;
        if (count > 0) {
            [variable.array removeObjectAtIndex:[self normalizedIndex:index forLength:count]];
        }
    });
}

- (void)removeLastItemInArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    dispatch_sync(self.serialQueue, ^{
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        NSUInteger count = variable.array.count;
        if (count > 0) {
            [variable.array removeObjectAtIndex:count - 1];
        }
    });
}

- (void)clearArrayVariable:(NSString *)variableName {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    dispatch_sync(self.serialQueue, ^{
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        [variable.array removeAllObjects];
    });
}

- (void)copyArrayFromVariable:(NSString *)variableName1 toVariable:(NSString *)variableName2 {
    NSAssert(variableName1 && ![variableName1 isEqualToString:@""], @"variable name 1 should not be empty");
    NSAssert(variableName2 && ![variableName2 isEqualToString:@""], @"variable name 2 should not be empty");
    
    if (![variableName1 isEqualToString:variableName2]) {
        dispatch_sync(self.serialQueue, ^{
            CPArrayVariable *variable1 = [self.arrayVariables objectForKey:variableName1];
            CPArrayVariable *variable2 = [self.arrayVariables objectForKey:variableName2];
            variable2.array = [variable1.array mutableCopy];
        });
    }
}

- (NSString *)stringByCombineArrayVariable:(NSString *)variableName delimiter:(NSString *)delimiter {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
    NSMutableString *result = [[NSMutableString alloc] init];
    BOOL first = YES;
    for (id<CPValue> value in variable.array) {
        if (first) {
            first = NO;
        } else if (delimiter) {
            [result appendString:delimiter];
        }
        [result appendString:value.stringValue];
    }
    return result;
}

- (void)splitString:(NSString *)string toArrayVariable:(NSString *)variableName delimiter:(NSString *)delimiter {
    NSAssert(variableName && ![variableName isEqualToString:@""], @"variable name should not be empty");
    
    dispatch_sync(self.serialQueue, ^{
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        [variable.array removeAllObjects];
        if (!delimiter || [delimiter isEqualToString:@""]) {
            for (int i = 0; i < string.length; i++) {
                [variable.array addObject:[CPStringValue valueWithString:[string substringWithRange:NSMakeRange(i, 1)]]];
            }
        } else {
            NSArray *components = [string componentsSeparatedByString:delimiter];
            for (NSString *component in components) {
                [variable.array addObject:[CPStringValue valueWithString:component]];
            }
        }
    });
}

- (void)stopExecute {
    dispatch_barrier_sync(self.serialQueue, ^{});
    self.serialQueue = NULL;
    
    for (NSString *variableName in self.valueVariables) {
        CPValueVariable *variable = [self.valueVariables objectForKey:variableName];
        variable.value = nil;
    }
    for (NSString *variableName in self.arrayVariables) {
        CPArrayVariable *variable = [self.arrayVariables objectForKey:variableName];
        variable.array = nil;
    }
}

#pragma mark - private methods

- (NSUInteger)normalizedIndex:(NSInteger)index forLength:(NSUInteger)length {
    NSAssert(length > 0, @"");
    NSUInteger normalizedIndex;
    if (index >= 0) {
        normalizedIndex = index % length;
    } else {
        normalizedIndex = (NSInteger)length + ((index + 1) % (NSInteger)length) - 1;
    }
    NSAssert(normalizedIndex >= 0 && normalizedIndex < length, @"");
    
    return normalizedIndex;
}

@end
