//
//  CPPromptArgument.m
//  DynamicArt
//
//  Created by wangyw on 4/5/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPromptArgument.h"

#import "CPStringValue.h"

@implementation CPPromptArgument

- (id)initWithString:(NSString *)text {
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock {
    [self setSize:[self sizeOfString:_text] notifyParentBlock:NO];
}

- (void)exportConstantToString:(NSMutableString *)string {
    [string appendString:[self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

@end
