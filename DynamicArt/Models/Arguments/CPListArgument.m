//
//  CPListArgument.m
//  DynamicArt
//
//  Created by wangyw on 4/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPListArgument.h"

#import "CPBlock.h"
#import "CPBlockController.h"
#import "CPNumberValue.h"

@implementation CPListArgument

static NSString *_EncodingKeyCurrentText = @"Text";

#pragma mark - property methods

- (NSArray *)listArray {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSString *)currentText {
    return [self.listArray objectAtIndex:self.index];
}

#pragma mark - lifecycle methods

- (id)initWithValue:(id<CPValue>)value {
    NSAssert([value isKindOfClass:[CPNumberValue class]], @"");
    
    self = [super init];
    if (self) {
        _index = value.intValue;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *currentText = [aDecoder decodeObjectForKey:_EncodingKeyCurrentText];
        if (!currentText || ![self.listArray containsObject:currentText]) {
            _index = 0;
        } else {
            _index = [self.listArray indexOfObject:currentText];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.currentText forKey:_EncodingKeyCurrentText];
}

#pragma mark -

- (void)updateIndex:(NSUInteger)index {
    NSAssert(self.index < self.listArray.count, @"");
    
    self.index = index;
    [self autoResizeByNotifyParentBlock:YES];
}

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock {
    [self resizeForString:self.currentText byNotifyParentBlock:notifyParentBlock];
}

@end
