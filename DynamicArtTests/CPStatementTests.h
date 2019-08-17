//
//  CPStatementTests.h
//  DynamicTests
//
//  Created by 咏武 王 on 12-3-1.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <XCTest/XCTest.h>

@class CPBreak;
@class CPSetVariable;
@class CPStartup;

@interface CPStatementTests : XCTestCase {
    CGPoint _originOfSetNumberVariable1;
    CPSetVariable *_setNumberVariable1;
    
    CGPoint _originOfSetNumberVariable2;
    CPSetVariable *_setNumberVariable2;
    
    CGPoint _originOfSetNumberVariable3;
    CPSetVariable *_setNumberVariable3;
    
    CGPoint _originOfStartup;
    CPStartup *_startup;
    
    CGPoint _originOfBreak;
    CPBreak *_break;
}

@end
