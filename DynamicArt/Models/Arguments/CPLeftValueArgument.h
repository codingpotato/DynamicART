//
//  CPArgumentLeftValue.h
//  DynamicArt
//
//  Created by wangyw on 3/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgument.h"

@interface CPLeftValueArgument : CPArgument

@property (strong, nonatomic) NSString *variableName;

- (void)updateVariableName:(NSString *)variableName;

@end
