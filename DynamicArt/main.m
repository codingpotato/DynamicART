//
//  main.m
//  DynamicArt
//
//  Created by wangyw on 8/11/12.
//  Copyright (c) 2012 wangyw. All rights reserved.
//

#import "CPAppDelegate.h"

#import "CPTrace.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([CPAppDelegate class]));
        }
        @catch (NSException *exception) {
            CPTrace(@"%@, %@", exception.name, exception.reason);
            for (NSString *callStackSymbol in exception.callStackSymbols) {
                CPTrace(@"%@", callStackSymbol);
            }
        }
    }
}
