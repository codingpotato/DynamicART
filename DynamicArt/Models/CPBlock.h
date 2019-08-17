//
//  CPBlock.h
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPArgument;
@class CPBlockConfiguration;
@class CPBlockController;
@class CPExpression;

extern NSString *CPBlockKeyPathFrame;
extern NSString *CPBlockKeyPathPickedUp;
extern NSString *CPBlockKeyPathRemoved;

@interface CPBlock : NSObject <NSCoding>

@property (weak, nonatomic) CPBlockController *blockController;

@property (strong, nonatomic) CPBlockConfiguration *configuration;

#pragma mark - notification properties

@property (nonatomic) CGRect frame;

@property (nonatomic, getter = isPickedUp) BOOL pickedUp;

@property (nonatomic, getter = isRemoved) BOOL removed;

#pragma mark - property methods

- (CPBlockConfiguration *)createConfiguration;

- (NSArray *)syntaxOrderArguments;

- (NSArray *)displayOrderArguments;

- (BOOL)isTopBlock;

#pragma mark - lifecycle methods

- (id)initAtOrigin:(CGPoint)origin;

- (void)didAddIntoBlockController;

- (void)didFinishFrameInit;

- (void)didRemoveFromBlockController;

#pragma mark - action methods

- (void)pickUpAllNextBlocks;

- (void)moveAllNextBlocksByTranslation:(CGPoint)translation;

- (void)putDownAllNextBlocks;

- (void)removeAllNextBlocks;

- (BOOL)connectedToOtherBlock;

- (void)detachFromOtherBlock;

- (void)pickUp;

- (void)moveByTranslation:(CGPoint)translation;

- (void)putDown;

- (void)remove;

- (void)performBlockOnAllNextBlocks:(void (^) (CPBlock *))codeBlock;

- (void)performBlock:(void (^) (CPBlock *))codeBlock;

#pragma mark - argument handle methods

- (void)arrangeArguments;

- (BOOL)areArgumentsInTwoLines;

- (void)argument:(CPArgument *)sender sizeChanged:(CGSize)deltaSize;

- (CPArgument *)argumentConnectedTo:(CPExpression *)expression;

- (void)stickAllExpressions;

- (void)increaseWidthBy:(CGFloat)deltaWidth;

- (CGFloat)centerOfFirstArgumentBar;

- (CGFloat)centerOfSecondArgumentBar;

- (void)increaseArgumentBarByHeight:(CGFloat)deltaHeight;

#pragma mark - export methods

- (void)exportAllNextBlockToString:(NSMutableString *)string level:(NSUInteger)level;

- (void)exportFirstArgumentLineToString:(NSMutableString *)string level:(NSUInteger)level;

- (void)exportSecondArgumentLineToString:(NSMutableString *)string level:(NSUInteger)level;

- (void)exportToString:(NSMutableString *)string level:(NSUInteger)level;

@end
