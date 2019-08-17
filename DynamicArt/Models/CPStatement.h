//
//  CPStatement.h
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlock.h"

@interface CPStatement : CPBlock

- (CGPoint)centerOfPlug;

- (CGPoint)centerOfSocketAtIndex:(NSUInteger)index;

- (NSUInteger)findConnectedSocketFromStatement:(CPStatement *)socketStatement;

- (CGFloat)maxWidthOfAllNextStatements;

- (CGFloat)heightOfAllNextStatements;

- (void)attachStatement:(CPStatement *)statement toSocket:(NSUInteger)index;

- (void)stickAllNextStatements;

- (void)executeAllFromSelf;

- (void)executeAllNextStatementsAtIndex:(NSUInteger)index;

- (void)execute;

@end
