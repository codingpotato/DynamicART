//
//  CPBlockBoard.h
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

@class CPCommand;

@class CPBlock;
@class CPConditions;
@class CPConfiguration;
@class CPExpression;
@class CPMyStartupManager;
@class CPStatement;
@class CPVariableManager;

extern NSString *CPBlockControllerVariableScreenWidth;
extern NSString *CPBlockControllerVariableScreenHeight;
extern NSString *CPBlockControllerVariableCurrentX;
extern NSString *CPBlockControllerVariableCurrentY;
extern NSString *CPBlockControllerVariableCurrentAngle;
extern NSString *CPBlockControllerVariablePreviousTouchX;
extern NSString *CPBlockControllerVariablePreviousTouchY;
extern NSString *CPBlockControllerVariableTouchX;
extern NSString *CPBlockControllerVariableTouchY;
extern NSString *CPBlockControllerVariableE;
extern NSString *CPBlockControllerVariablePi;
extern NSString *CPBlockControllerVariableGoldenRatio;

extern NSString *CPBlockControllerKeyPathAppName;
extern NSString *CPBlockControllerKeyPathOffset;
extern NSString *CPBlockControllerKeyPathSize;
extern NSString *CPBlockControllerKeyPathPlugAndSocketConnected;
extern NSString *CPBlockControllerKeyPathUICommand;

@interface CPBlockController : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *blocks;

@property (strong, nonatomic) CPVariableManager *variableManager;

@property (strong, nonatomic) CPMyStartupManager *myStartupManager;

@property (nonatomic) CGRect frameOfConnectIndicator;

@property (atomic, readonly, getter = isForceQuit) BOOL forceQuit;

@property (strong, nonatomic) CPConditions *conditions;

@property (nonatomic, readonly) CGFloat pageSize;

#pragma mark - notification properties

@property (strong, nonatomic) NSString *appName;

@property (nonatomic) CGPoint offset;

@property (nonatomic) CGSize size;

@property (nonatomic) BOOL plugAndSocketConnected;

@property (strong, nonatomic) CPCommand *uiCommand;

#pragma mark - lifecycle methods

- (id)initWithBlockBoardSize:(CGSize)blockBoardSize;

# pragma mark - block management methods

- (void)blockFrameChanged:(CGRect)blockFrame;

- (CPBlock *)createBlockOfClass:(Class)class atOrigin:(CGPoint)origin;

- (void)removeAll;

- (void)removeOneBlockFromBlockController:(CPBlock *)block;

- (void)pickUpBlocksFrom:(CPBlock *)block;

- (void)moveBlocksFrom:(CPBlock *)block byTranslation:(CGPoint)translation;

- (void)putDownBlocksFrom:(CPBlock *)block;

- (void)removeBlocksFrom:(CPBlock *)block;

- (void)findConnectionToExpression:(CPExpression *)movedExpression;

- (void)findConnectionToStatement:(CPStatement *)movedStatement;

- (void)attachBlock;

- (void)alignBlocks;

- (void)deepTraversePerformBlock:(void (^) (CPBlock *))codeBlock;

- (void)disconnectCurrentPlugAndSocket;

- (void)disconnectCurrentArgumentAndExpression;

#pragma mark - execute methods

- (void)startExecute;

- (void)stopExecute;

- (void)stageBeginTouchAt:(CGPoint)touchPoint;

- (void)stageTouchMoveTo:(CGPoint)touchPoint from:(CGPoint)previoustouchPoint;

- (void)stageTouchEnd;

- (void)sendUiCommand:(CPCommand *)uiCommand;

#pragma mark - export methods

- (void)exportAllBlocksToString:(NSMutableString *)string;

@end
