//
//  CPMyStartupManager.m
//  DynamicArt
//
//  Created by wangyw on 10/21/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMyStartupManager.h"

#import "CPException.h"
#import "CPMyStartup.h"

@interface CPMyStartupManager ()

@property (strong, nonatomic) NSMutableDictionary *myStartups;

@end

@implementation CPMyStartupManager

#pragma mark - property methods

- (NSString *)lastUsedStartupName {
    static NSString *defaultStartupName = @"My Blockette";
    
    if (_useDefaultStartupName || !_lastUsedStartupName || [_lastUsedStartupName isEqualToString:@""]) {
        return defaultStartupName;
    } else {
        return _lastUsedStartupName;
    }
}

- (NSArray *)myStartupNames {
    return [[self.myStartups allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
}

- (NSMutableDictionary *)myStartups {
    if (!_myStartups) {
        _myStartups = [[NSMutableDictionary alloc] init];
    }
    return _myStartups;
}

#pragma mark -

- (void)addMyStartup:(CPMyStartup *)myStartup {
    NSAssert(myStartup.name, @"");
    
    NSMutableSet *myStartupsWithSameName = [self.myStartups objectForKey:myStartup.name];
    if (!myStartupsWithSameName) {
        myStartupsWithSameName = [[NSMutableSet alloc] init];
        [self.myStartups setObject:myStartupsWithSameName forKey:myStartup.name];
    }
    [myStartupsWithSameName addObject:myStartup];
    
    self.lastUsedStartupName = myStartup.name;
}

- (void)removeMyStartup:(CPMyStartup *)myStartup {
    NSMutableSet *myStartupsWithSameName = [self.myStartups objectForKey:myStartup.name];
    if (myStartupsWithSameName) {
        [myStartupsWithSameName removeObject:myStartup];
     
        if (myStartupsWithSameName.count == 0) {
            [self.myStartups removeObjectForKey:myStartup.name];
            if ([self.lastUsedStartupName isEqualToString:myStartup.name]) {
                self.lastUsedStartupName = nil;
            }
        }
    }
}

- (void)executeMyStartupsOfName:(NSString *)name {
    NSMutableSet *myStartupsWithSameName = [self.myStartups objectForKey:name];
    for (CPMyStartup *myStartup in myStartupsWithSameName) {
        @try {
            [myStartup executeAllFromSelf];
        } @catch (CPReturnException *exception) {
        }
    }
}

@end
