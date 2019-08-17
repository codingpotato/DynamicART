//
//  CPBlockBoardTests.h
//  PolymerTests
//
//  Created by 咏武 王 on 12-2-29.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <XCTest/XCTest.h>

@class CPAdd;
@class CPBlockController;
@class CPStartup;
@class CPSetVariable;

@interface CPBlockControllerTests : XCTestCase {
@private
    CPBlockController *_blockController;
    
    CGPoint _originOfSetNumberVariable;
    CPSetVariable *_setNumberVariable;
    
    CGPoint _originOfStartup;
    CPStartup *_startup;
    
    CGPoint _originOfAdd;
    CPAdd *_add;
}

@end
