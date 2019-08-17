//
//  CPVariableManager.h
//  DynamicArt
//
//  Created by wangyw on 3/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPValue;

@interface CPVariableManager : NSObject

@property (nonatomic) BOOL useDefaultVariableName;

@property (weak, nonatomic) NSString *lastUsedUserValueVariableName;

@property (weak, nonatomic) NSString *lastUsedUserArrayVariableName;

- (void)addBuildinValueVariableByName:(NSString *)variableName;

- (NSArray *)allValueVariableNames;

- (NSArray *)allUserValueVariableNames;

- (NSArray *)allArrayVariableNames;

- (BOOL)containsValueVariable:(NSString *)variableName;

- (BOOL)containsArrayVariable:(NSString *)variableName;

- (void)retainValueVariableByName:(NSString *)variableName;

- (void)retainArrayVariableByName:(NSString *)variableName;

- (void)releaseValueVariableByName:(NSString *)variableName;

- (void)releaseArrayVariableByName:(NSString *)variableName;

- (NSUInteger)retainCountForValueVariable:(NSString *)variableName;

- (NSUInteger)retainCountForArrayVariable:(NSString *)variableName;

- (id<CPValue>)valueOfVariable:(NSString *)variableName;

- (void)setValue:(id<CPValue>)value forVariable:(NSString *)variableName;

- (NSUInteger)countOfArrayVariable:(NSString *)variableName;

- (id<CPValue>)valueAtIndex:(NSInteger)index ofArrayVariable:(NSString *)variableName;

- (void)addValue:(id<CPValue>)value inArrayVariable:(NSString *)variableName;

- (void)insertValue:(id<CPValue>)value atIndex:(NSInteger)index inArrayVariable:(NSString *)variableName;

- (void)replaceValue:(id<CPValue>)value atIndex:(NSInteger)index inArrayVariable:(NSString *)variableName;

- (void)removeValueAtIndex:(NSInteger)index inArrayVariable:(NSString *)variableName;

- (void)removeLastItemInArrayVariable:(NSString *)variableName;

- (void)clearArrayVariable:(NSString *)variableName;

- (void)copyArrayFromVariable:(NSString *)variableName1 toVariable:(NSString *)variableName2;

- (NSString *)stringByCombineArrayVariable:(NSString *)variableName delimiter:(NSString *)delimiter;

- (void)splitString:(NSString *)string toArrayVariable:(NSString *)variableName delimiter:(NSString *)delimiter;

- (void)stopExecute;

@end
