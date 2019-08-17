//
//  CPArgument.m
//  DynamicArt
//
//  Created by wangyw on 3/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgument.h"

#import "CPGeometryHelper.h"

#import "CPBlock.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPExpression.h"

NSString *CPArgumentKeyPathConnectedToExpression = @"connectedToExpression";
NSString *CPArgumentKeyPathHidden = @"hidden";

@interface CPArgument ()

@property (weak, nonatomic) CPExpression *expression;

@property (weak, nonatomic) CPExpression *tempDecodedExpression;

@end

@implementation CPArgument

#pragma mark - lifecycle methods

static NSString *_encodingKeyExpression = @"Expression";

- (id)initWithValue:(id<CPValue>)value {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _tempDecodedExpression = [aDecoder decodeObjectForKey:_encodingKeyExpression];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeConditionalObject:self.expression forKey:_encodingKeyExpression];
}

- (void)didAddIntoParentBlock {
    NSAssert(_parentBlock, @"");
    [self autoResizeByNotifyParentBlock:NO];
}

- (void)didFinishFrameInit {
    if (self.tempDecodedExpression) {
        [self attachExpression:self.tempDecodedExpression];
        self.tempDecodedExpression = nil;
    }
}

- (void)didRemoveFromParentBlock {
}

#pragma mark - property methods

- (CPBlock *)parentBlock {
    NSAssert(_parentBlock, @"");
    return _parentBlock;
}

- (CPVariableManager *)variableManager {
    NSAssert(self.parentBlock.blockController.variableManager, @"");
    return self.parentBlock.blockController.variableManager;
}

- (CPMyStartupManager *)myStartupManager {
    NSAssert(self.parentBlock.blockController.myStartupManager, @"");
    return self.parentBlock.blockController.myStartupManager;
}

- (CPBlockConfiguration *)blockConfiguration {
    return self.parentBlock.configuration;
}

- (void)setOrigin:(CGPoint)origin {
    if (!CGPointEqualToPoint(_frame.origin, origin)) {
        _frame.origin = origin;
        [self stickExpression];
    }
}

- (void)setSize:(CGSize)size notifyParentBlock:(BOOL)notifyParentBlock {
    if (!CGSizeEqualToSize(size, _frame.size)) {
        CGSize deltaSize = CGSizeMake(size.width - _frame.size.width, size.height - _frame.size.height);
        _frame.size = size;
        if (notifyParentBlock) {
            [self.parentBlock argument:self sizeChanged:deltaSize];
        }
    }
}

- (CGFloat)verticalSpace {
    return 8.0;
}

#pragma mark - size adjust methods

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)resizeForString:(NSString *)string byNotifyParentBlock:(BOOL)notifyParentBlock {
    if (!self.isHidden) {
        CGSize size = [self sizeOfString:string];
        size.width += self.verticalSpace;
        [self setSize:size notifyParentBlock:notifyParentBlock];
    }
}

- (CGSize)sizeOfString:(NSString *)string {
    CGSize size;
    if (!string || [string isEqualToString:@""]) {
        size = [@"0" sizeWithAttributes:@{NSFontAttributeName: self.parentBlock.configuration.argumentFont}];
        size.width = 0.0;
    } else {
        size = [string sizeWithAttributes:@{NSFontAttributeName: self.parentBlock.configuration.argumentFont}];
    }
    return size;
}

#pragma mark - expression methods

- (CPArgument *)argumentNearToExpression:(CPExpression *)expression {
    NSAssert(expression, @"");
    
    CPArgument *nearArgument = [self.expression argumentConnectedTo:expression];
    if (nearArgument) {
        return nearArgument;
    } else {
        if ([self canConnectToExpression:expression] && CGRectIntersectsRect(CPRectTranslate(self.frame, self.parentBlock.frame.origin), expression.frame)) {
            if (!self.connectedToExpression) {
                self.connectedToExpression = YES;
            }
            return self;
        } else {
            if (self.connectedToExpression) {
                self.connectedToExpression = NO;
            }
            return nil;
        }
    }
}

- (BOOL)canConnectToExpression:(CPExpression *)expression {
    return NO;
}

- (void)attachExpression:(CPExpression *)expression {
    NSAssert(expression && self.parentBlock != expression, @"");
    
    [self detachExpression];
    self.expression = expression;
    expression.parentArgument = self;
    
    [self stickExpression];
    
    [self setSize:self.expression.frame.size notifyParentBlock:YES];
    self.hidden = YES;
}

- (void)detachExpression {
    if (self.expression) {
        self.expression.parentArgument = nil;
        self.expression = nil;        
        self.hidden = NO;
        [self autoResizeByNotifyParentBlock:YES];
    }
}

- (id<CPValue>)calculateExpressionResult {
    return [self.expression calculateResult];
}

- (void)pickUpExpression {
    [self.expression pickUp];
}

- (void)moveExpressionByTranslation:(CGPoint)translation {
    [self.expression moveByTranslation:translation];
}

- (void)putDownExpression {
    [self.expression putDown];
}

- (void)stickExpression {
    if (self.expression) {
        CGPoint origin = CPPointTranslate(self.frame.origin, self.parentBlock.frame.origin);
        self.expression.frame = CPRectMoveOriginTo(self.expression.frame, origin);
        [self.expression stickAllExpressions];
    }
}

- (void)removeExpression {
    [self.expression remove];
}

- (void)performBlockOnExpression:(void (^) (CPBlock *))codeBlock {
    [self.expression performBlock:codeBlock];
}

#pragma mark - export methods

- (void)exportToString:(NSMutableString *)string {
    if (self.expression) {
        [string appendString:@" ["];
        [self.expression exportToString:string level:0];
        [string appendString:@"] "];
    } else {
        [string appendString:@" "];
        [self exportConstantToString:string];
        [string appendString:@" "];
    }
}

- (void)exportConstantToString:(NSMutableString *)string {
    [self doesNotRecognizeSelector:_cmd];
}

@end
