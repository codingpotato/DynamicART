//
//  CPBlockMockup.h
//  DynamicArt
//
//  Created by 咏武 王 on 3/12/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPStatement.h"

#import "CPBlockConfiguration.h"

@interface CPStatementMockup : CPStatement

@property (nonatomic, weak) CPArgument *sizeChangedArgument;

@property (nonatomic) CGSize deltaSizeOfArgument;

+ (void)setExpectedColor:(CPBlockConfigurationColor)color;

+ (void)setExpectedHeadOfBlocks:(BOOL)headOfBlocks;

+ (void)setExpectedNumberOfSockets:(int)numberOfSockets;

@end
