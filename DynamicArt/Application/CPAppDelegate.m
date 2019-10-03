//
//  CPAppDelegate.m
//  DynamicArt
//
//  Created by wangyw on 8/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPAppDelegate.h"

#import "CPApplicationController.h"

@implementation CPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [CPApplicationController loadAppFromUrl:url];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
