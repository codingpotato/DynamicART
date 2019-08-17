//
//  CPValueTests.m
//  DynamicArt
//
//  Created by 王咏武 on 3/18/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPValueTests.h"

#import "CPNumberValue.h"

@implementation CPValueTests

- (void)testCPValueInteger {
    int expectedInteger = 10;
    NSString *expectedString = @"10";
    CPNumberValue *value = [CPNumberValue valueWithDouble:expectedInteger];
    XCTAssertEqual(value.intValue, expectedInteger, @"");
    XCTAssertEqual(value.doubleValue, (double)expectedInteger, @"");
    XCTAssertTrue([value.stringValue isEqualToString:expectedString], @"");
}
                  
- (void)testCPValueIntegerEncoding {
    int expectedInteger = 10;
    NSString *expectedString = @"10";
    CPNumberValue *value = [CPNumberValue valueWithDouble:expectedInteger];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    value = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    XCTAssertEqual(value.intValue, expectedInteger, @"");
    XCTAssertEqual(value.doubleValue, (double)expectedInteger, @"");
    XCTAssertTrue([value.stringValue isEqualToString:expectedString], @"");
}

@end
