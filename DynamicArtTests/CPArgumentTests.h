//
//  CPArgumentTests.h
//  DynamicArt
//
//  Created by 咏武 王 on 3/12/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import <XCTest/XCTest.h>

@class CPBlockController;
@class CPRightValueWeakTypeArgument;
@class CPStatementMockup;
@class CPSub;

@interface CPArgumentTests : XCTestCase {
@private
    CPBlockController *_blockController;
    CPStatementMockup *_parentBlock;
    CPRightValueWeakTypeArgument *_argument;
    
    CPSub *_sub;
}

@end
