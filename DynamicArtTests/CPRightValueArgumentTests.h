//
//  CPRightValueArgumentTests.h
//  DynamicArt
//
//  Created by 王咏武 on 4/12/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import <XCTest/XCTest.h>

@protocol CPValue;

@class CPStatementMockup;
@class CPRightValueWeakTypeArgument;

@interface CPRightValueArgumentTests : XCTestCase {
@private
    CPStatementMockup *_parentBlock;
    id<CPValue> _value;
    CPRightValueWeakTypeArgument *_argument;
}

@end
