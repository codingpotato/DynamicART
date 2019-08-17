//
//  CPVariableManagerTests.m
//  DynamicArt
//
//  Created by 咏武 王 on 3/10/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPVariableManagerTests.h"

#import "CPNumberValue.h"
#import "CPVariableManager.h"

@implementation CPVariableManagerTests

- (void)setUp {
    [super setUp];
    
    _variableManager = [[CPVariableManager alloc] init];
}

- (void)tearDown {
    [_variableManager stopExecute];
    _variableManager = nil;
    
    [super tearDown];
}

- (void)testInit {
    XCTAssertNotNil(_variableManager, @"");    
    NSArray *variableNames = _variableManager.allValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)0, @"");
    variableNames = _variableManager.allUserValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)0, @"");
    variableNames = _variableManager.allArrayVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)0, @"");
}

- (void)testRetainVariable {
    NSString *variableName = @"variable name";
    [_variableManager retainValueVariableByName:variableName];
    XCTAssertTrue([variableName isEqualToString:_variableManager.lastUsedUserValueVariableName], @"");
    
    NSArray *variableNames = _variableManager.allValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)1, @"");
    XCTAssertTrue([variableName isEqualToString:[variableNames objectAtIndex:0]], @"");
    
    variableNames = _variableManager.allUserValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)1, @"");
    XCTAssertTrue([variableName isEqualToString:[variableNames objectAtIndex:0]], @"");
}

- (void)testReleaseVariable {
    NSString *variableName = @"variable name";
    [_variableManager retainValueVariableByName:variableName];
    [_variableManager releaseValueVariableByName:variableName];
    
    NSArray *variableNames = _variableManager.allValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)0, @"");
    variableNames = _variableManager.allUserValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)0, @"");
}

- (void)testRetainVariableTwice {
    NSString *variableName = @"variable name";
    [_variableManager retainValueVariableByName:variableName];
    [_variableManager retainValueVariableByName:variableName];
    XCTAssertTrue([variableName isEqualToString:_variableManager.lastUsedUserValueVariableName], @"");
    
    NSArray *variableNames = _variableManager.allValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)1, @"");
    XCTAssertTrue([variableName isEqualToString:[variableNames objectAtIndex:0]], @"");
    variableNames = _variableManager.allUserValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)1, @"");
    XCTAssertTrue([variableName isEqualToString:[variableNames objectAtIndex:0]], @"");
    
    [_variableManager releaseValueVariableByName:variableName];

    variableNames = _variableManager.allValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)1, @"");
    XCTAssertTrue([variableName isEqualToString:[variableNames objectAtIndex:0]], @"");
    variableNames = _variableManager.allUserValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)1, @"");
    XCTAssertTrue([variableName isEqualToString:[variableNames objectAtIndex:0]], @"");
    
    [_variableManager releaseValueVariableByName:variableName];

    variableNames = _variableManager.allValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)0, @"");
    variableNames = _variableManager.allUserValueVariableNames;
    XCTAssertEqual(variableNames.count, (NSUInteger)0, @"");
}

- (void)testSetValue {
    NSString *variableName = @"variable name";
    [_variableManager retainValueVariableByName:variableName];
    
    id<CPValue> expectedValue = [CPNumberValue valueWithDouble:100.0];
    [_variableManager setValue:expectedValue forVariable:variableName];
    XCTAssertEqual([_variableManager valueOfVariable:variableName], expectedValue, @"");
}

@end
