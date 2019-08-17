//
//  CPExpressionTests.h
//  DynamicArt
//
//  Created by 咏武 王 on 3/8/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import <XCTest/XCTest.h>

@class CPAdd;
@class CPBlockController;
@class CPRepeat;
@class CPSetVariable;

@interface CPExpressionTests : XCTestCase {
@private
    CPBlockController *_blockController;
    
    CGPoint _originOfSetVariable;
    CPSetVariable *_setVariable;
    
    CGPoint _originOfAdd1;
    CPAdd *_add1;

    CGPoint _originOfAdd2;
    CPAdd *_add2;
    
    CGPoint _originOfRepeat;
    CPRepeat *_repeat;
}

@end
