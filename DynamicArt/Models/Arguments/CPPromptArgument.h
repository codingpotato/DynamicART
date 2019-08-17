//
//  CPPromptArgument.h
//  DynamicArt
//
//  Created by wangyw on 4/5/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgument.h"

@class CPStringValue;

@interface CPPromptArgument : CPArgument

@property (strong, nonatomic) NSString *text;

- (id)initWithString:(NSString *)text;

@end
