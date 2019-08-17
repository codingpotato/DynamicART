//
//  CPBlockBoard.m
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlockController.h"

#import "CPGeometryHelper.h"
#import "CPTrace.h"

#import "CPArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBooleanValue.h"
#import "CPConditions.h"
#import "CPException.h"
#import "CPExpression.h"
#import "CPMyStartup.h"
#import "CPMyStartupManager.h"
#import "CPNumberValue.h"
#import "CPPerform.h"
#import "CPStartup.h"
#import "CPVariableManager.h"
#import "CPWhenTouchBegin.h"
#import "CPWhenTouchEnd.h"
#import "CPWhenTouchMove.h"

NSString *CPBlockControllerVariableScreenWidth = @"screen width";
NSString *CPBlockControllerVariableScreenHeight = @"screen height";
NSString *CPBlockControllerVariableCurrentX = @"current x";
NSString *CPBlockControllerVariableCurrentY = @"current y";
NSString *CPBlockControllerVariableCurrentAngle = @"current angle";
NSString *CPBlockControllerVariablePreviousTouchX = @"previous touch x";
NSString *CPBlockControllerVariablePreviousTouchY = @"previous touch y";
NSString *CPBlockControllerVariableTouchX = @"touch x";
NSString *CPBlockControllerVariableTouchY = @"touch y";
NSString *CPBlockControllerVariableE = @"e (Euler Number)";
NSString *CPBlockControllerVariablePi = @"\u03C0 (Pi)";
NSString *CPBlockControllerVariableGoldenRatio = @"\u03D5 (Golden Ratio)";

NSString *CPBlockControllerKeyPathAppName = @"appName";
NSString *CPBlockControllerKeyPathOffset = @"offset";
NSString *CPBlockControllerKeyPathSize = @"size";
NSString *CPBlockControllerKeyPathPlugAndSocketConnected = @"plugAndSocketConnected";
NSString *CPBlockControllerKeyPathUICommand = @"uiCommand";

static NSString *_encodingKeyAppName = @"AppName";
static NSString *_encodingKeyBlocks = @"Blocks";
static NSString *_encodingKeySize = @"Size";
static NSString *_encodingKeyOffset = @"Offset";

@interface CPBlockController ()

@property (strong, nonatomic) NSMutableArray *headStatements;

@property (nonatomic) dispatch_queue_t eventExecuteQueue;

@property (weak, nonatomic) CPStatement *connectedPlugStatement;
@property (weak, nonatomic) CPStatement *connectedSocketStatement;
@property (nonatomic) NSUInteger indexOfConnectedSocket;

@property (weak, nonatomic) CPArgument *connectedArgument;
@property (weak, nonatomic) CPExpression *connectedExpression;

- (BOOL)findConnectedArgumentOfBlock:(CPBlock *)block toExpression:(CPExpression *)expression;

- (BOOL)findConnectedSocketOfStatement:(CPStatement *)socketStatement toPlugStatement:(CPStatement *)plugStatement;

- (CGRect)connectIndicatorFrameToSocketStatement:(CPStatement *)socketStatement indexOfSocket:(NSUInteger)indexOfSocket;

- (CGRect)connectIndicatorFrameToPlugStatement:(CPStatement *)plugStatement;

- (void)dispatchTouchEventToHeadStatement:(CPHeadStatement *)headStatement;

@end

@implementation CPBlockController

#pragma mark - property methods

- (NSMutableArray *)blocks {
    if (!_blocks) {
        _blocks = [NSMutableArray array];
    }
    return _blocks;
}

- (CGFloat)pageSize {
    return 1024.0;
}

- (NSMutableArray *)headStatements {
    if (!_headStatements) {
        _headStatements = [NSMutableArray array];
    }
    return _headStatements;
}

- (CPVariableManager *)variableManager {
    if (!_variableManager) {
        _variableManager = [[CPVariableManager alloc] init];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableScreenWidth];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableScreenHeight];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableCurrentX];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableCurrentY];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableCurrentAngle];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariablePreviousTouchX];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariablePreviousTouchY];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableTouchX];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableTouchY];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableE];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariablePi];
        [_variableManager addBuildinValueVariableByName:CPBlockControllerVariableGoldenRatio];
    }
    return _variableManager;
}

- (CPMyStartupManager *)myStartupManager {
    if (!_myStartupManager) {
        _myStartupManager = [[CPMyStartupManager alloc] init];
    }
    return _myStartupManager;
}

- (dispatch_queue_t)eventExecuteQueue {
    if (!_eventExecuteQueue) {
        _eventExecuteQueue = dispatch_queue_create("codingpotato.eventExecuteQueue", NULL);
    }
    return _eventExecuteQueue;
}

- (CPConditions *)conditions {
    if (!_conditions) {
        _conditions = [[CPConditions alloc] init];
    }
    return _conditions;
}

#pragma mark - lifecycle methods

- (id)initWithBlockBoardSize:(CGSize)blockBoardSize {
    self = [super init];
    if (self) {
        _size = CGSizeMake(self.pageSize, self.pageSize);
        _offset = CGPointMake((self.pageSize - blockBoardSize.width) / 2, (self.pageSize - blockBoardSize.height) / 2);

        CPTrace(@"%@ init", self);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _blocks = [aDecoder decodeObjectForKey:_encodingKeyBlocks];
        _appName = [aDecoder decodeObjectForKey:_encodingKeyAppName];
        _size = [aDecoder decodeCGSizeForKey:_encodingKeySize];
        _offset = [aDecoder decodeCGPointForKey:_encodingKeyOffset];

        for (CPBlock *block in _blocks) {
            block.blockController = self;
            if ([block isKindOfClass:[CPHeadStatement class]]) {
                [self.headStatements addObject:block];
            }
        }
        for (CPBlock *block in _blocks) {
            [block didAddIntoBlockController];
        }
        for (CPBlock *block in _blocks) {
            [block didFinishFrameInit];
        }
        CPTrace(@"%@ init from decoder", self);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.blocks forKey:_encodingKeyBlocks];
    [aCoder encodeObject:self.appName forKey:_encodingKeyAppName];
    [aCoder encodeCGSize:self.size forKey:_encodingKeySize];
    [aCoder encodeCGPoint:self.offset forKey:_encodingKeyOffset];
}

- (void)dealloc {
    CPTrace(@"%@ dealloc", self);
}

# pragma mark - block management methods

- (void)blockFrameChanged:(CGRect)blockFrame {
    CGPoint offset = self.offset;
    CGSize size = self.size;
    if (blockFrame.origin.x < 0) {
        size.width += self.pageSize;
        self.size = size;
        for (CPBlock *block in self.blocks) {
            block.frame = CPRectTranslate(block.frame, CGPointMake(self.pageSize, 0.0));
        }
        offset.x += self.pageSize;
        self.offset = offset;
    } else {
        BOOL sizeChanged = NO;
        if (blockFrame.origin.x + blockFrame.size.width > size.width) {
            int pageX = (int)((blockFrame.origin.x + blockFrame.size.width) / self.pageSize) + 1;
            size.width = pageX * self.pageSize;
            sizeChanged = YES;
        }
        if (blockFrame.origin.y + blockFrame.size.height > size.height) {
            int pageY = (int)((blockFrame.origin.y + blockFrame.size.height) / self.pageSize) + 1;
            size.height = pageY * self.pageSize;
            sizeChanged = YES;
        }
        if (sizeChanged) {
            self.size = size;
        }
    }
}

- (CPBlock *)createBlockOfClass:(Class)class atOrigin:(CGPoint)origin {
    CPBlock *block = [[class alloc] initAtOrigin:origin];
    NSAssert(block, @"");
    [self.blocks addObject:block];
    block.blockController = self;
    if ([block isKindOfClass:[CPHeadStatement class]]) {
        [self.headStatements addObject:block];
    }
    [block didAddIntoBlockController];
    [block didFinishFrameInit];
    return block;
}

- (void)removeAll {
    while (self.blocks.count > 0) {
        CPBlock *block = [self.blocks objectAtIndex:0];
        [self removeBlocksFrom:block];
    }    
}

- (void)removeOneBlockFromBlockController:(CPBlock *)block {
    NSAssert(block, @"");
    
    if (self.plugAndSocketConnected && (self.connectedPlugStatement == block || self.connectedSocketStatement == block)) {
        [self disconnectCurrentPlugAndSocket];
    }
    if (self.connectedArgument && self.connectedExpression == block) {
        [self disconnectCurrentArgumentAndExpression];
    }
    [self.blocks removeObject:block];
    [block didRemoveFromBlockController];
}

- (void)pickUpBlocksFrom:(CPBlock *)block {
    [block detachFromOtherBlock];
    if (block.configuration.numberOfSockets) {
        [block pickUpAllNextBlocks];
    } else {
        [block pickUp];
    }
}

- (void)moveBlocksFrom:(CPBlock *)block byTranslation:(CGPoint)translation {
    if (block.configuration.numberOfSockets) {
        [block moveAllNextBlocksByTranslation:translation];
    } else {
        [block moveByTranslation:translation];
    }
    
    if ([block isKindOfClass:[CPStatement class]]) {
        [self findConnectionToStatement:(CPStatement *)block];
    } else if ([block isKindOfClass:[CPExpression class]]) {
        [self findConnectionToExpression:(CPExpression *)block];
    }
}

- (void)putDownBlocksFrom:(CPBlock *)block {
    if (block.configuration.numberOfSockets) {
        [block putDownAllNextBlocks];
    } else {
        [block putDown];
    }
    [self attachBlock];
}

- (void)removeBlocksFrom:(CPBlock *)block {
    if (block.configuration.numberOfSockets) {
        [block removeAllNextBlocks];
        if ([block isKindOfClass:[CPHeadStatement class]]) {
            [self.headStatements removeObject:block];
            if ([block isKindOfClass:[CPMyStartup class]]) {
                [self.myStartupManager removeMyStartup:(CPMyStartup *)block];
            }
        }
    } else {
        [block remove];
    }
}

- (void)findConnectionToExpression:(CPExpression *)movedExpression {
    if (self.connectedArgument) {
        CPArgument *connectedArgument = [self.connectedArgument argumentNearToExpression:self.connectedExpression];
        if (connectedArgument && connectedArgument != self.connectedArgument) {
            self.connectedArgument.connectedToExpression = NO;
        }
        self.connectedArgument = connectedArgument;
    } else {
        for (CPBlock *block in self.blocks) {
            if (!block.isPickedUp && [self findConnectedArgumentOfBlock:block toExpression:movedExpression]) {
                break;
            }
        }
    }
}

- (void)findConnectionToStatement:(CPStatement *)movedStatement {
    if (self.plugAndSocketConnected) {
        NSUInteger indexOfConnectedSocket = self.indexOfConnectedSocket;
        if ([self findConnectedSocketOfStatement:self.connectedSocketStatement toPlugStatement:self.connectedPlugStatement]) {
            if (self.indexOfConnectedSocket != indexOfConnectedSocket) {
                // indexOfConnectedSocket was changed
                if (movedStatement == self.connectedPlugStatement) {
                    self.frameOfConnectIndicator = [self connectIndicatorFrameToSocketStatement:self.connectedSocketStatement indexOfSocket:self.indexOfConnectedSocket];
                    self.plugAndSocketConnected = YES;
                } else if (movedStatement == self.connectedSocketStatement) {
                    self.frameOfConnectIndicator = [self connectIndicatorFrameToPlugStatement:self.connectedPlugStatement];
                    self.plugAndSocketConnected = YES;
                }
            }
        } else {
            self.connectedPlugStatement = nil;
            self.connectedSocketStatement = nil;
            self.plugAndSocketConnected = NO;
        }
    } else {
        for (CPBlock *block in self.blocks) {
            if (!block.isPickedUp && [block isKindOfClass:[CPStatement class]]) {
                CPStatement *statement = (CPStatement *)block;
                if ([self findConnectedSocketOfStatement:statement toPlugStatement:movedStatement]) {
                    self.frameOfConnectIndicator = [self connectIndicatorFrameToSocketStatement:statement indexOfSocket:self.indexOfConnectedSocket];
                    self.plugAndSocketConnected = YES;
                    break;
                }
                if ([self findConnectedSocketOfStatement:movedStatement toPlugStatement:statement]) {
                    self.frameOfConnectIndicator = [self connectIndicatorFrameToPlugStatement:statement];
                    self.plugAndSocketConnected = YES;
                    break;
                }
            }
        }
    }
}

- (void)attachBlock {
    if (self.plugAndSocketConnected) {
        [self.connectedSocketStatement attachStatement:self.connectedPlugStatement toSocket:self.indexOfConnectedSocket];
        [self disconnectCurrentPlugAndSocket];
    }
    if  (self.connectedArgument) {
        [self.connectedArgument attachExpression:_connectedExpression];
        [self disconnectCurrentArgumentAndExpression];
    }
}

- (void)alignBlocks {
    static const CGFloat seperator = 40.0, topY = 84.0;
    CGFloat x = seperator, y = topY, maxWidth = 0.0, maxY = 0.0;
    
    for (int index = 0; index < 3; index++) {
        for (CPHeadStatement *headStatement in self.headStatements) {
            if ((index == 0 && [headStatement isKindOfClass:[CPStartup class]]) ||
                (index == 1 && [headStatement isKindOfClass:[CPMyStartup class]]) ||
                (index == 2 && ![headStatement isKindOfClass:[CPStartup class]] && ![headStatement isKindOfClass:[CPMyStartup class]])) {
                [headStatement pickUpAllNextBlocks];
                [headStatement moveAllNextBlocksByTranslation:CGPointMake(x - headStatement.frame.origin.x, y - headStatement.frame.origin.y)];
                [headStatement putDownAllNextBlocks];
                
                CGFloat width = headStatement.maxWidthOfAllNextStatements;
                if (width > maxWidth) {
                    maxWidth = width;
                }
                CGFloat height = headStatement.heightOfAllNextStatements;
                y += height + seperator;
            }
        }
        if (y > maxY) {
            maxY = y;
        }
        if (y > topY) {
            x += maxWidth + seperator;
            y = topY;
            maxWidth = 0.0;
        }
    }
    
    maxWidth = 0.0;
    for (CPBlock *block in self.blocks) {
        if ([block isKindOfClass:[CPStatement class]] && ![block isKindOfClass:[CPHeadStatement class]] && !block.connectedToOtherBlock) {
            CPStatement *statement = (CPStatement *)block;
            [statement pickUpAllNextBlocks];
            [statement moveAllNextBlocksByTranslation:CGPointMake(x - block.frame.origin.x, y - block.frame.origin.y)];
            [statement putDownAllNextBlocks];
            
            CGFloat width = statement.maxWidthOfAllNextStatements;
            if (width > maxWidth) {
                maxWidth = width;
            }
            CGFloat height = statement.heightOfAllNextStatements;
            y += height + seperator;
        }
    }
    x += maxWidth + seperator;
    if (y > maxY) {
        maxY = y;
    }
    y = topY;
    
    maxWidth = 0.0;
    for (CPBlock *block in self.blocks) {
        if ([block isKindOfClass:[CPExpression class]] && !block.connectedToOtherBlock) {
            [block pickUp];
            [block moveByTranslation:CGPointMake(x - block.frame.origin.x, y - block.frame.origin.y)];
            [block putDown];
            if (block.frame.size.width > maxWidth) {
                maxWidth = block.frame.size.width;
            }
            y += block.frame.size.height + seperator;
        }
    }
    if (maxWidth > 0) {
        x += maxWidth;
    } else {
        x -= seperator;
    }
    if (y > maxY) {
        maxY = y;
    }
    self.size = CGSizeMake(((int)(x / self.pageSize + 1)) * self.pageSize, ((int)(maxY / self.pageSize + 1)) * self.pageSize);
}

- (void)deepTraversePerformBlock:(void (^)(CPBlock *))codeBlock {
    for (CPBlock *block in self.blocks) {
        if (block.isTopBlock) {
            if (block.configuration.numberOfSockets) {
                [block performBlockOnAllNextBlocks:codeBlock];
            } else {
                [block performBlock:codeBlock];
            }
        }
    }
}

- (void)disconnectCurrentPlugAndSocket {
    self.connectedPlugStatement = nil;
    self.connectedSocketStatement = nil;
    self.plugAndSocketConnected = NO;
}

- (void)disconnectCurrentArgumentAndExpression {
    self.connectedArgument.connectedToExpression = NO;
    self.connectedArgument = nil;
    self.connectedExpression = nil;
}

#pragma mark - execute methods

static const dispatch_queue_priority_t _globalQueuePriority = DISPATCH_QUEUE_PRIORITY_BACKGROUND; 

- (void)startExecute {
    _forceQuit = NO;
    [CPPerform resetRecursionDepth];
    
    [_variableManager setValue:[CPNumberValue valueWithDouble:M_E] forVariable:CPBlockControllerVariableE];
    [_variableManager setValue:[CPNumberValue valueWithDouble:M_PI] forVariable:CPBlockControllerVariablePi];
    [_variableManager setValue:[CPNumberValue valueWithDouble:(sqrt(5.0) + 1) / 2] forVariable:CPBlockControllerVariableGoldenRatio];
    [self.variableManager setValue:[CPNumberValue valueWithDouble:-1.0] forVariable:CPBlockControllerVariablePreviousTouchX];
    [self.variableManager setValue:[CPNumberValue valueWithDouble:-1.0] forVariable:CPBlockControllerVariablePreviousTouchY];
    [self.variableManager setValue:[CPNumberValue valueWithDouble:-1.0] forVariable:CPBlockControllerVariableTouchX];
    [self.variableManager setValue:[CPNumberValue valueWithDouble:-1.0] forVariable:CPBlockControllerVariableTouchY];
    
    for (CPHeadStatement *headStatement in self.headStatements) {
        if ([headStatement isKindOfClass:[CPStartup class]]) {
            dispatch_async(dispatch_get_global_queue(_globalQueuePriority, 0), ^{
                CPTrace(@"Start execute %@", headStatement);
                
                @try {
                    [headStatement executeAllFromSelf];
                } @catch (CPBreakException *exception) {
                } @catch (CPContinueException *exception) {
                } @catch (CPReturnException *exception) {
                } @catch (NSException *exception) {
                    CPTrace(@"%@, %@, %@", exception.name, exception.reason, exception.userInfo);
                    for (NSString *callStackSymbol in exception.callStackSymbols) {
                        CPTrace(@"%@", callStackSymbol);
                    }
                }
                
                CPTrace(@"Stop execute %@", headStatement);
            });
        }
    }
}

- (void)stopExecute {
    CPTrace(@"Require stop execute");
    
    _forceQuit = YES;
    [_conditions stopExecute];
    _conditions = nil;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(_globalQueuePriority, 0);
    dispatch_barrier_sync(globalQueue, ^{
    });
    [self.variableManager stopExecute];
    self.eventExecuteQueue = NULL;

    CPTrace(@"Stop execute finished");
}

- (void)stageBeginTouchAt:(CGPoint)touchPoint {
    dispatch_async(self.eventExecuteQueue, ^{
        id<CPValue> touchX = [CPNumberValue valueWithDouble:touchPoint.x];
        id<CPValue> touchY = [CPNumberValue valueWithDouble:touchPoint.y];
        [self.variableManager setValue:touchX forVariable:CPBlockControllerVariableTouchX];
        [self.variableManager setValue:touchY forVariable:CPBlockControllerVariableTouchY];
    });

    dispatch_async(self.eventExecuteQueue, ^{
        [self.conditions broadcastTouch];
    });

    for (CPHeadStatement *headStatement in self.headStatements) {
        if ([headStatement isKindOfClass:[CPWhenTouchBegin class]]) {
            [self dispatchTouchEventToHeadStatement:headStatement];
        }
    }
}

- (void)stageTouchMoveTo:(CGPoint)touchPoint from:(CGPoint)previoustouchPoint {
    dispatch_async(self.eventExecuteQueue, ^{
        id<CPValue> previousTouchX = [CPNumberValue valueWithDouble:previoustouchPoint.x];
        id<CPValue> previousTouchY = [CPNumberValue valueWithDouble:previoustouchPoint.y];
        id<CPValue> touchX = [CPNumberValue valueWithDouble:touchPoint.x];
        id<CPValue> touchY = [CPNumberValue valueWithDouble:touchPoint.y];
        [self.variableManager setValue:previousTouchX forVariable:CPBlockControllerVariablePreviousTouchX];
        [self.variableManager setValue:previousTouchY forVariable:CPBlockControllerVariablePreviousTouchY];
        [self.variableManager setValue:touchX forVariable:CPBlockControllerVariableTouchX];
        [self.variableManager setValue:touchY forVariable:CPBlockControllerVariableTouchY];
    });

    for (CPHeadStatement *headStatement in self.headStatements) {
        if ([headStatement isKindOfClass:[CPWhenTouchMove class]]) {
            [self dispatchTouchEventToHeadStatement:headStatement];
        }
    }
}

- (void)stageTouchEnd {
    for (CPHeadStatement *headStatement in self.headStatements) {
        if ([headStatement isKindOfClass:[CPWhenTouchEnd class]]) {
            [self dispatchTouchEventToHeadStatement:headStatement];
        }
    }
}

- (void)sendUiCommand:(CPCommand *)uiCommand {
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.uiCommand = uiCommand;
    });
}

#pragma mark - export methods

- (void)exportAllBlocksToString:(NSMutableString *)string {
    for (int index = 0; index < 3; index++) {
        for (CPHeadStatement *headStatement in self.headStatements) {
            if ((index == 0 && [headStatement isKindOfClass:[CPStartup class]]) ||
                (index == 1 && [headStatement isKindOfClass:[CPMyStartup class]]) ||
                (index == 2 && ![headStatement isKindOfClass:[CPStartup class]] && ![headStatement isKindOfClass:[CPMyStartup class]])) {
                [headStatement exportAllNextBlockToString:string level:0];
            }
        }
    }
}

#pragma mark - private methods

- (BOOL)findConnectedArgumentOfBlock:(CPBlock *)block toExpression:(CPExpression *)expression {
    self.connectedArgument = [block argumentConnectedTo:expression];
    if (self.connectedArgument) {
        self.connectedExpression = expression;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)findConnectedSocketOfStatement:(CPStatement *)socketStatement toPlugStatement:(CPStatement *)plugStatement {
    self.indexOfConnectedSocket = [plugStatement findConnectedSocketFromStatement:socketStatement];
    if (self.indexOfConnectedSocket != NSNotFound) {
        NSAssert(self.indexOfConnectedSocket >= 0 && self.indexOfConnectedSocket < socketStatement.configuration.numberOfSockets, @"");
        self.connectedPlugStatement = plugStatement;
        self.connectedSocketStatement = socketStatement;
        return YES;
    } else {
        return NO;
    }
}

- (CGRect)connectIndicatorFrameToSocketStatement:(CPStatement *)socketStatement indexOfSocket:(NSUInteger)indexOfSocket {
    NSAssert(indexOfSocket >= 0 && indexOfSocket < socketStatement.configuration.numberOfSockets, @"");
    
    CGFloat width = socketStatement.frame.size.width;
    if (socketStatement.configuration.numberOfSockets > 1 && indexOfSocket < socketStatement.configuration.numberOfSockets - 1) {
        width -= socketStatement.configuration.widthOfLeftBar;
    }
    CGPoint centerOfSocket = [socketStatement centerOfSocketAtIndex:indexOfSocket];
    return CGRectMake(centerOfSocket.x - socketStatement.configuration.leftOfPlugCenter, centerOfSocket.y - socketStatement.configuration.heightOfPlugCenter, width, 20.0);
}

- (CGRect)connectIndicatorFrameToPlugStatement:(CPStatement *)plugStatement {
    return CGRectMake(plugStatement.frame.origin.x, plugStatement.frame.origin.y - 15.0, plugStatement.frame.size.width, 20.0);
}

- (void)dispatchTouchEventToHeadStatement:(CPHeadStatement *)headStatement {
    dispatch_async(self.eventExecuteQueue, ^{
        @try {
            [headStatement executeAllFromSelf];
        }
        @catch (CPBreakException *exception) {
        }
        @catch (CPContinueException *exception) {
        }
        @catch (CPReturnException *exception) {
        }
        @catch (NSException *exception) {
            CPTrace(@"%@, %@, %@", exception.name, exception.reason, exception.userInfo);
            for (NSString *callStackSymbol in exception.callStackSymbols) {
                CPTrace(@"%@", callStackSymbol);
            }
        }
    });
}

@end
