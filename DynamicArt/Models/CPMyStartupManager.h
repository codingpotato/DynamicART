//
//  CPMyStartupManager.h
//  DynamicArt
//
//  Created by wangyw on 10/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPMyStartup;

@interface CPMyStartupManager : NSObject

@property (nonatomic) BOOL useDefaultStartupName;

@property (weak, nonatomic) NSString *lastUsedStartupName;

- (NSArray *)myStartupNames;

- (void)addMyStartup:(CPMyStartup *)myStartup;

- (void)removeMyStartup:(CPMyStartup *)myStartup;

- (void)executeMyStartupsOfName:(NSString *)name;

@end
