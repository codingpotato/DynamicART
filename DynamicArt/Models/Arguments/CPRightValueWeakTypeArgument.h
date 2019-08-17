//
//  CPRightValueWeakTypeArgument.h
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgument.h"

@interface CPRightValueWeakTypeArgument : CPArgument

@property (strong, nonatomic) id<CPValue> value;

@property (strong, nonatomic) NSString *variableName;

- (void)updateValue:(id<CPValue>)value;

- (void)updateVariableName:(NSString *)variableName;

- (id<CPValue>)calculateResult;

@end
