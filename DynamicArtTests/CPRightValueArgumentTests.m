//
//  CPRightValueArgumentTests.m
//  DynamicArt
//
//  Created by 王咏武 on 4/12/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRightValueArgumentTests.h"

#import "CPStatementMockup.h"

#import "CPNumberValue.h"
#import "CPRightValueStrongTypeArgument.h"

@implementation CPRightValueArgumentTests

- (void)setUp {
    [super setUp];
    
    _parentBlock = [[CPStatementMockup alloc] init];
    _value = [CPNumberValue valueWithDouble:10.0];
    _argument = [[CPRightValueWeakTypeArgument alloc] initWithValue:_value];
    _argument.parentBlock = _parentBlock;
}

- (void)tearDown {
    _parentBlock = nil;
    _argument = nil;
    
    [super tearDown];    
}

- (void)testInit {
    XCTAssertEqual(_argument.value, _value, @"");
}

- (void)testEncoding {
    double expectedFloatValue = 100.0;
    [_argument setValue:[CPNumberValue valueWithDouble:expectedFloatValue]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_argument];
    CPRightValueWeakTypeArgument *newArgument = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertEqual(newArgument.value.doubleValue, expectedFloatValue, @"");
}

@end
