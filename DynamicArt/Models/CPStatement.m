//
//  Block.m
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

#import "CPStatement.h"

#import "CPGeometryHelper.h"

#import "CPArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPHeadStatement.h"

@interface CPStatement ()

@property (strong, nonatomic) NSMutableArray *centerOfSockets;

@property (weak, nonatomic) CPStatement *previousStatement;

@property (strong, nonatomic) NSMutableArray *nextStatements;

@property (strong, nonatomic) NSMutableArray *tempDecodeNextStatements;

@end

@implementation CPStatement

static NSString * _EncodingKeyOrigin = @"Origin";
static NSString * _EncodingKeyNextStatement = @"NextStatement_%d";

- (BOOL)isTopBlock {
    return self.previousStatement == nil;
}

#pragma mark - lifecycle methods

- (id)initAtOrigin:(CGPoint)origin {
    self = [super initAtOrigin:origin];
    if (self) {
        if (self.configuration.numberOfSockets > 0) {
            self.frame = CPRectSetHeight(self.frame, [self centerOfSocketAtIndex:self.configuration.numberOfSockets - 1].y - self.frame.origin.y);
        } else {
            self.frame = CPRectSetHeight(self.frame, self.configuration.heightOfPlugImage + self.configuration.heightOfSocketImage);
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGPoint origin = [aDecoder decodeCGPointForKey:_EncodingKeyOrigin];
        /*
         * file saved by retina hardware will have position .5
         * round to interge to avoid unclear picture
         */
        origin.x = round(origin.x);
        origin.y = round(origin.y);
        self.frame = CPRectMoveOriginTo(self.frame, origin);
        if (self.configuration.numberOfSockets > 0) {
            self.frame = CPRectSetHeight(self.frame, [self centerOfSocketAtIndex:self.configuration.numberOfSockets - 1].y - self.frame.origin.y);
            
            _tempDecodeNextStatements = [NSMutableArray arrayWithCapacity:self.configuration.numberOfSockets - 1];
            for (int index = 0; index < self.configuration.numberOfSockets; index++) {
                CPStatement *statement = [aDecoder decodeObjectForKey:[[NSString alloc] initWithFormat:_EncodingKeyNextStatement, index]];
                if (statement) {
                    [_tempDecodeNextStatements addObject:statement];
                } else {
                    [_tempDecodeNextStatements addObject:[NSNull null]];
                }
            }
        } else {
            self.frame = CPRectSetHeight(self.frame, self.configuration.heightOfPlugImage + self.configuration.heightOfSocketImage);
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    if (!self.previousStatement) {
        [aCoder encodeCGPoint:self.frame.origin forKey:_EncodingKeyOrigin];
    }
    for (int index = 0; index < self.configuration.numberOfSockets; index++) {
        CPStatement *statement = [self nextStatementAtIndex:index];
        if (statement) {
            [aCoder encodeConditionalObject:statement forKey:[[NSString alloc] initWithFormat:_EncodingKeyNextStatement, index]];
        }
    }
}

- (void)didFinishFrameInit {
    [super didFinishFrameInit];
    
    if (self.tempDecodeNextStatements) {
        for (int index = 0; index < self.configuration.numberOfSockets; index++) {
            id statement = [self.tempDecodeNextStatements objectAtIndex:index];
            if (statement != [NSNull null]) {
                [self attachStatement:statement toSocket:index];
            }
        }
        self.tempDecodeNextStatements = nil;
    }
}

#pragma mark -

- (CGPoint)centerOfPlug {
    return CPPointTranslate(CGPointMake(self.configuration.leftOfPlugCenter, self.configuration.heightOfPlugCenter), self.frame.origin);
}

- (CGPoint)centerOfSocketAtIndex:(NSUInteger)index {
    NSAssert(index < self.configuration.numberOfSockets, @"index: %lu not in range 0-%d", (unsigned long)index, self.configuration.numberOfSockets);

    NSValue *centerOfSocket = [self.centerOfSockets objectAtIndex:index];
    return CPPointTranslate(centerOfSocket.CGPointValue, self.frame.origin);
}

- (NSUInteger)findConnectedSocketFromStatement:(CPStatement *)socketStatement {
    if (self.previousStatement) {
        return NSNotFound;
    } else {
        NSUInteger index = 0;
        while (index < socketStatement.configuration.numberOfSockets && ![self isNearFromPoint1:self.centerOfPlug toPoint2:[socketStatement centerOfSocketAtIndex:index]]) {
            index++;
        }
        return index < socketStatement.configuration.numberOfSockets ? index : NSNotFound;
    }
}

- (CGFloat)maxWidthOfAllNextStatements {
    CGFloat width = 0.0;
    CPStatement *statement = self;
    while (statement) {
        if (statement.frame.size.width > width) {
            width = statement.frame.size.width;
        }
        for (int index = 0; index < statement.configuration.numberOfSockets - 1; index++) {
            CPStatement *innerStatement = [statement nextStatementAtIndex:index];
            if (innerStatement) {
                CGFloat innerWidth = innerStatement.maxWidthOfAllNextStatements + statement.configuration.widthOfLeftBar;
                if (innerWidth > width) {
                    width = innerWidth;
                }
            }
        }
        statement = statement.lastNextStatement;
    }
    return width;
}

- (CGFloat)heightOfAllNextStatements {
    CGFloat height = 0.0;
    CPStatement *statement = self;
    while (statement) {
        height += statement.frame.size.height - statement.configuration.heightOfPlugCenter;
        statement = statement.lastNextStatement;
    }
    height += self.configuration.heightOfPlugCenter;
    return height;
}

- (void)attachStatement:(CPStatement *)statement toSocket:(NSUInteger)index {
    NSAssert(self != statement, @"");
    NSAssert(![statement isKindOfClass:[CPHeadStatement class]], @"");
    NSAssert(self.configuration.numberOfSockets > 0, @"");
    NSAssert(index < self.configuration.numberOfSockets, @"");
    
    CPStatement *lastAttachedStatement = statement;
    while (lastAttachedStatement.lastNextStatement) {
        lastAttachedStatement = lastAttachedStatement.lastNextStatement;
    }
    CPStatement *nextStatement = [self nextStatementAtIndex:index];
    if (nextStatement) {
        [nextStatement detachFromOtherBlock];
        if (lastAttachedStatement.configuration.numberOfSockets > 0) {
            [lastAttachedStatement attachStatement:nextStatement toSocket:lastAttachedStatement.configuration.numberOfSockets - 1];
        }
    }
    [self setNextStatement:statement atIndex:index];
    statement.previousStatement = self;
    
    CGFloat height = statement.heightOfAllNextStatements - self.configuration.heightOfPlugCenter;
    if (index < self.configuration.numberOfSockets - 1) {
        height -= self.configuration.heightOfInnerSpace;
    }
    if (![self increaseHeightBy:height forSocket:(int)index]) {
        [self stickAllNextStatements];
    }
}

- (void)stickAllNextStatements {
    [self performOnAllNextStatements:^(CPStatement *statement) {
        [statement stickNextStatements];
    }];
}

#pragma mark - execute methods

- (void)executeAllFromSelf {
    CPStatement *executingStatement = self;
    while (!self.blockController.isForceQuit && executingStatement) {
        [executingStatement execute];
        executingStatement = executingStatement.lastNextStatement;
    }
}

- (void)executeAllNextStatementsAtIndex:(NSUInteger)index {
    NSAssert(index < self.configuration.numberOfSockets, @"");
    [[self nextStatementAtIndex:index] executeAllFromSelf];
}

- (void)execute {
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - methods from super

- (BOOL)connectedToOtherBlock {
    return self.previousStatement != nil;
}

- (void)detachFromOtherBlock {
    if (self.previousStatement) {
        NSUInteger index = [self.previousStatement indexOfSocketForAttachedStatement:self];
        NSAssert1(index != NSNotFound, @"should find child statement: %@", self);
        NSAssert(self.previousStatement.configuration.numberOfSockets > 0, @"");

        CPStatement *lastDetachedStatement = self;
        while (lastDetachedStatement) {
            lastDetachedStatement = lastDetachedStatement.lastNextStatement;
        }
        CPStatement *previousStatement = self.previousStatement;
        [self.previousStatement resetNextStatementAtIndex:index];
        self.previousStatement = nil;

        CGFloat height = -self.heightOfAllNextStatements + self.configuration.heightOfPlugCenter;
        if (index < previousStatement.configuration.numberOfSockets - 1) {
            height += self.configuration.heightOfInnerSpace;
        }
        if (![previousStatement increaseHeightBy:height forSocket:(int)index]) {
            [previousStatement stickAllNextStatements];
        }
    }
}

- (CGFloat)centerOfFirstArgumentBar {
    if (self.configuration.numberOfSockets) {
        if (self.areArgumentsInTwoLines && self.configuration.numberOfSockets == 1) {
            return self.frame.size.height / 4 + self.configuration.heightOfPlugCenter;
        } else {
            NSValue *centerOfSocket = [self.centerOfSockets objectAtIndex:0];
            return centerOfSocket.CGPointValue.y / 2;
        }
    } else {
        return self.frame.size.height / 2;
    }
}

- (CGFloat)centerOfSecondArgumentBar {
    if (self.areArgumentsInTwoLines && self.configuration.numberOfSockets == 1) {
        return self.frame.size.height * 3 / 4;
    } else {
        NSAssert(self.configuration.numberOfSockets > 1, @"");
        NSValue *centerOfSocket = [self.centerOfSockets objectAtIndex:1];
        return centerOfSocket.CGPointValue.y - 25.0;
    }
}

- (void)increaseArgumentBarByHeight:(CGFloat)deltaHeight {
    [self increaseHeightBy:deltaHeight forSocket:-1];
}

- (void)pickUpAllNextBlocks {
    [self performOnAllNextStatements:^(CPStatement *statement) {
        [statement pickUp];
    }];
}

- (void)moveAllNextBlocksByTranslation:(CGPoint)translation {
    [self performOnAllNextStatements:^(CPStatement *statement) {
        [statement moveByTranslation:translation];
    }];
}

- (void)putDownAllNextBlocks {
    [self performOnAllNextStatements:^(CPStatement *statement) {
        [statement putDown];
    }];
}

- (void)removeAllNextBlocks {
    [self performOnAllNextStatements:^(CPStatement *statement) {
        [statement remove];
    }];
}

- (void)pickUp {
    [super pickUp];
    for (int index = 0; index < self.configuration.numberOfSockets - 1; index++) {
        [[self nextStatementAtIndex:index] pickUpAllNextBlocks];
    }
}

- (void)moveByTranslation:(CGPoint)translation {
    [super moveByTranslation:translation];
    for (int index = 0; index < self.configuration.numberOfSockets - 1; index++) {
        [[self nextStatementAtIndex:index]  moveAllNextBlocksByTranslation:translation];
    }
}

- (void)putDown {
    [super putDown];
    for (int index = 0; index < self.configuration.numberOfSockets - 1; index++) {
        [[self nextStatementAtIndex:index] putDownAllNextBlocks];
    }
}

- (void)remove {
    [super remove];
    for (int index = 0; index < self.configuration.numberOfSockets - 1; index++) {
        [[self nextStatementAtIndex:index] removeAllNextBlocks];
    }
}

- (void)performBlockOnAllNextBlocks:(void (^)(CPBlock *))codeBlock {
    [self performOnAllNextStatements:^(CPStatement *statement) {
        [statement performBlock:codeBlock];
    }];
}

- (void)performBlock:(void (^)(CPBlock *))codeBlock {
    [super performBlock:codeBlock];
    for (int index = 0; index < self.configuration.numberOfSockets - 1; index++) {
        [[self nextStatementAtIndex:index] performBlockOnAllNextBlocks:codeBlock];
    }
}

#pragma mark - export methods

- (void)exportAllNextBlockToString:(NSMutableString *)string level:(NSUInteger)level {
    [self performOnAllNextStatements:^(CPStatement *statement) {
        [statement exportToString:string level:level];
    }];
}

- (void)exportToString:(NSMutableString *)string level:(NSUInteger)level {
    for (int i = 0; i < level; i++) {
        [string appendString:@"    "];
    }
    if ([self isKindOfClass:[CPHeadStatement class]]) {
        [string appendString:@"----------"];
    }
    [super exportToString:string level:level];
    if ([self isKindOfClass:[CPHeadStatement class]]) {
        [string appendString:@"----------"];
    }
    
    if (self.configuration.numberOfSockets > 1) {
        [string appendString:@"|"];
        [[self nextStatementAtIndex:0] exportAllNextBlockToString:string level:level + 1];
    }

    [self exportSecondArgumentLineToString:string level:level];
    if (self.configuration.numberOfSockets > 2) {
        [string appendString:@"|"];
        [[self nextStatementAtIndex:1] exportAllNextBlockToString:string level:level + 1];
    }
    if (self.configuration.numberOfSockets > 1) {
        for (int i = 0; i < level; i++) {
            [string appendString:@"    "];
        }
        [string appendString:@" End"];
    }
    [string appendString:@"|"];
}

#pragma mark - private methods

- (NSMutableArray *)centerOfSockets {
    if (!_centerOfSockets && self.createConfiguration.numberOfSockets > 0) {
        _centerOfSockets = [NSMutableArray arrayWithCapacity:self.configuration.numberOfSockets];
        CGFloat y = self.configuration.heightOfPlugImage + self.configuration.heightOfSocketImage;
        for (NSUInteger index = 0; index < self.configuration.numberOfSockets; index++) {
            if (index == self.configuration.numberOfSockets - 1) {
                [_centerOfSockets addObject:[NSValue valueWithCGPoint:CGPointMake(self.configuration.leftOfPlugCenter, y)]];
            } else if (index == self.configuration.numberOfSockets - 2) {
                [_centerOfSockets addObject:[NSValue valueWithCGPoint:CGPointMake(self.configuration.widthOfLeftBar + self.configuration.leftOfPlugCenter, y)]];
                y += self.configuration.heightOfInnerBottomSocketImage;
            } else {
                [_centerOfSockets addObject:[NSValue valueWithCGPoint:CGPointMake(self.configuration.widthOfLeftBar + self.configuration.leftOfPlugCenter, y)]];
                y += self.configuration.heightOfInnerSocketImage;
            }
        }
    }
    return _centerOfSockets;
}

- (NSMutableArray *)nextStatements {
    if (!_nextStatements) {
        _nextStatements = [[NSMutableArray alloc] initWithCapacity:self.configuration.numberOfSockets];
        for (int i = 0; i < self.configuration.numberOfSockets; i++) {
            [_nextStatements addObject:[NSNull null]];
        }
    }
    return _nextStatements;
}

- (CPStatement *)nextStatementAtIndex:(NSUInteger)index {
    if (self.configuration.numberOfSockets > 0) {
        
        NSAssert(index < self.nextStatements.count, @"");
        id statement = [self.nextStatements objectAtIndex:index];
        if (statement != [NSNull null]) {
            return statement;
        }
    }
    return nil;
}

- (CPStatement *)lastNextStatement {
    if (self.configuration.numberOfSockets > 0) {
        id statement = [self.nextStatements lastObject];
        if (statement != [NSNull null]) {
            return statement;
        }
    }
    return nil;
}

- (void)setNextStatement:(CPStatement *)statement atIndex:(NSUInteger)index {
    NSAssert(self.configuration.numberOfSockets > 0, @"");
    NSAssert(index < self.nextStatements.count, @"");
    NSAssert(statement, @"");
    
    [self.nextStatements replaceObjectAtIndex:index withObject:statement];
}

- (void)resetNextStatementAtIndex:(NSUInteger)index {
    NSAssert(self.configuration.numberOfSockets > 0, @"");
    NSAssert(index < self.nextStatements.count, @"");
    
    [self.nextStatements replaceObjectAtIndex:index withObject:[NSNull null]];
}

- (void)setLastNextStatement:(CPStatement *)statement {
    NSAssert(self.configuration.numberOfSockets > 0, @"");
    NSAssert(self.nextStatements.count > 0, @"");
    NSAssert(statement, @"");
    
    [self.nextStatements replaceObjectAtIndex:self.nextStatements.count - 1 withObject:statement];
}

- (void)resetLastNextStatement {
    NSAssert(self.configuration.numberOfSockets > 0, @"");
    NSAssert(self.nextStatements.count > 0, @"");
    
    [self.nextStatements replaceObjectAtIndex:self.nextStatements.count - 1 withObject:[NSNull null]];
}

- (BOOL)isNearFromPoint1:(CGPoint)point1 toPoint2:(CGPoint)point2 {
    static const CGFloat connectionDistance = 30.0;
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrtf(dx * dx + dy * dy) <= connectionDistance;
}

- (void)stickNextStatements {
    for (int index = 0; index < self.configuration.numberOfSockets; index++) {
        CPStatement *nextStatement = [self nextStatementAtIndex:index];
        CGPoint origin = [self centerOfSocketAtIndex:index];
        origin.x -= self.configuration.leftOfPlugCenter;
        origin.y -= self.configuration.heightOfPlugCenter;
        if (nextStatement) {
            nextStatement.frame = CPRectMoveOriginTo(nextStatement.frame, origin);
            [nextStatement stickAllExpressions];
        }
        if (index < self.configuration.numberOfSockets - 1) {
            [nextStatement stickAllNextStatements];
        }
    }
}

- (BOOL)increaseHeightBy:(CGFloat)height forSocket:(int)index {
    NSAssert(self.configuration.numberOfSockets > 0, @"");
    NSAssert(index >= -1 && index < self.configuration.numberOfSockets, @"");
    
    if (self.configuration.numberOfSockets > 0) {
        if (index != self.configuration.numberOfSockets - 1) {
            for (int i = index + 1; i < self.configuration.numberOfSockets; i++) {
                NSValue *centerOfSocket = [self.centerOfSockets objectAtIndex:i];
                [self.centerOfSockets replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:CPPointTranslateByY(centerOfSocket.CGPointValue, height)]];
            }
            
            [self stickAllNextStatements];
            [self increaseHeightOfContainerStatementBy:height];
            self.frame = CPRectIncreaseHeight(self.frame, height);
            
            if (self.configuration.numberOfSockets > 1 && self.areArgumentsInTwoLines) {
                [self arrangeArguments];
            }
            
            return YES;
        }
    }
    return [self increaseHeightOfContainerStatementBy:height];
}

- (BOOL)increaseHeightOfContainerStatementBy:(CGFloat)height {
    CPStatement *childStatement = self;
    CPStatement *containerStatement = self.previousStatement;
    while (containerStatement && containerStatement.lastNextStatement == childStatement) {
        childStatement = containerStatement;
        containerStatement = containerStatement.previousStatement;
    }
    if (containerStatement) {
        NSUInteger index = [containerStatement indexOfSocketForAttachedStatement:childStatement];
        NSAssert1(index != NSNotFound, @"should find child statement: %@", self);
        [containerStatement increaseHeightBy:height forSocket:(int)index];
        return YES;
    } else {
        return NO;
    }
}

- (NSUInteger)indexOfSocketForAttachedStatement:(CPStatement *)statement {
    return [self.nextStatements indexOfObject:statement];
}

- (void)performOnAllNextStatements:(void (^)(CPStatement *))block {
    CPStatement *statement = self;
    while (statement) {
        block(statement);
        statement = statement.lastNextStatement;
    }
}

@end
