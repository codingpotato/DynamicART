//
//  CPArgument.h
//  DynamicArt
//
//  Created by wangyw on 3/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPValue;

@class CPBlock;
@class CPBlockConfiguration;
@class CPExpression;
@class CPMyStartupManager;
@class CPVariableManager;

extern NSString *CPArgumentKeyPathConnectedToExpression;
extern NSString *CPArgumentKeyPathHidden;

@interface CPArgument : NSObject <NSCoding>

@property (weak, nonatomic) CPBlock *parentBlock;

@property (nonatomic, readonly) CGRect frame;

@property (nonatomic) NSUInteger syntaxOrderIndex;

#pragma mark - notification properties

@property (nonatomic) BOOL connectedToExpression;

@property (nonatomic, getter = isHidden) BOOL hidden;

#pragma mark - lifecycle methods

- (id)initWithValue:(id<CPValue>)value;

- (void)didAddIntoParentBlock;

- (void)didFinishFrameInit;

- (void)didRemoveFromParentBlock;

#pragma mark - property methods

- (CPVariableManager *)variableManager;

- (CPMyStartupManager *)myStartupManager;

- (CPBlockConfiguration *)blockConfiguration;

- (void)setOrigin:(CGPoint)origin;

- (void)setSize:(CGSize)size notifyParentBlock:(BOOL)notifyParentBlock;

- (CGFloat)verticalSpace;

#pragma mark - size adjust methods

- (void)resizeForString:(NSString *)string byNotifyParentBlock:(BOOL)notifyParentBlock;

- (void)autoResizeByNotifyParentBlock:(BOOL)notifyParentBlock;

- (CGSize)sizeOfString:(NSString *)string;

#pragma mark - expression methods

- (CPArgument *)argumentNearToExpression:(CPExpression *)expression;

- (BOOL)canConnectToExpression:(CPExpression *)expression;

- (void)attachExpression:(CPExpression *)expression;

- (void)detachExpression;

- (id<CPValue>)calculateExpressionResult;

- (void)pickUpExpression;

- (void)moveExpressionByTranslation:(CGPoint)translation;

- (void)putDownExpression;

- (void)stickExpression;

- (void)removeExpression;

- (void)performBlockOnExpression:(void (^) (CPBlock *))codeBlock;

#pragma mark - export methods

- (void)exportToString:(NSMutableString *)string;

- (void)exportConstantToString:(NSMutableString *)string;

@end
