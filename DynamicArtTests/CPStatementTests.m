//
//  CPStatementTests.m
//  DynamicTests
//
//  Created by 咏武 王 on 12-3-1.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

#import "CPStatementTests.h"

#import "CPGeometryHelper.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPBreak.h"
#import "CPStartup.h"
#import "CPSetVariable.h"

@implementation CPStatementTests

- (void)setUp {
    [super setUp];
    
    _originOfSetNumberVariable1 = CGPointMake(100.0, 10.0);
    _setNumberVariable1 = [[CPSetVariable alloc] initAtOrigin:_originOfSetNumberVariable1];
    
    _originOfSetNumberVariable2 = CGPointMake(100.0, 90.0);
    _setNumberVariable2 = [[CPSetVariable alloc] initAtOrigin:_originOfSetNumberVariable2];

    _originOfSetNumberVariable3 = CGPointMake(100.0, 170.0);
    _setNumberVariable3 = [[CPSetVariable alloc] initAtOrigin:_originOfSetNumberVariable3];
    
    _originOfStartup = CGPointMake(100.0, 270.0);
    _startup = [[CPStartup alloc] initAtOrigin:_originOfStartup];
    
    _originOfBreak = CGPointMake(100.0, 370.0);
    _break = [[CPBreak alloc] initAtOrigin:_originOfBreak];
}

- (void)tearDown {    
    _setNumberVariable1 = nil;
    _setNumberVariable2 = nil;
    _setNumberVariable3 = nil;
    _startup = nil;
    _break = nil;

    [super tearDown];
}

- (void)testInit {
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, _originOfSetNumberVariable1), @"");
    XCTAssertEqual(_setNumberVariable1.frame.size.height, _setNumberVariable1.configuration.heightOfPlugImage + _setNumberVariable1.configuration.heightOfSocketImage, @"");
    
    XCTAssertTrue(CGPointEqualToPoint(_startup.frame.origin, _originOfStartup), @"");
    XCTAssertEqual(_startup.frame.size.height, _startup.configuration.heightOfPlugImage + _startup.configuration.heightOfSocketImage, @"");
    
    XCTAssertTrue(CGPointEqualToPoint(_break.frame.origin, _originOfBreak), @"");
    XCTAssertEqual(_startup.frame.size.height, _break.configuration.heightOfPlugImage + _break.configuration.heightOfNoSocketImage, @"");
}

- (void)testCenterOfPlug {
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.centerOfPlug, CPPointTranslate(_originOfSetNumberVariable1, CGPointMake(_setNumberVariable1.configuration.leftOfPlugCenter, _setNumberVariable1.configuration.heightOfPlugCenter))), @"");
    XCTAssertThrows([_startup centerOfPlug], @"");
    XCTAssertTrue(CGPointEqualToPoint(_break.centerOfPlug, CPPointTranslate(_originOfBreak, CGPointMake(_break.configuration.leftOfPlugCenter, _break.configuration.heightOfPlugCenter))), @"");
}

- (void)testCenterOfSocketAt {
    XCTAssertEqual(_setNumberVariable1.configuration.numberOfSockets, 1, @"");
    XCTAssertTrue(CGPointEqualToPoint([_setNumberVariable1 centerOfSocketAtIndex:0], CPPointTranslate(_originOfSetNumberVariable1, CGPointMake(_setNumberVariable1.configuration.leftOfPlugCenter, _setNumberVariable1.frame.size.height))), @"");
    XCTAssertThrows([_setNumberVariable1 centerOfSocketAtIndex:1], @"");
    XCTAssertEqual(_startup.configuration.numberOfSockets, 1, @"");
    XCTAssertTrue(CGPointEqualToPoint([_startup centerOfSocketAtIndex:0], CPPointTranslate(_originOfStartup, CGPointMake(_startup.configuration.leftOfPlugCenter, _startup.frame.size.height))), @"");
    XCTAssertThrows([_startup centerOfSocketAtIndex:1], @"");
    XCTAssertEqual(_break.configuration.numberOfSockets, 0, @"");
    XCTAssertThrows([_break centerOfSocketAtIndex:0], @"");
}

- (void)testAttachOneStatement {
    XCTAssertEqual(_startup.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");

    [_startup attachStatement:_setNumberVariable1 toSocket:0];
    [_startup pickUpAllNextBlocks];
    XCTAssertEqual(_startup.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, YES, @"");
    
    CGPoint translation = CGPointMake(10.0, 10.0);
    [_startup moveAllNextBlocksByTranslation:translation];
    XCTAssertTrue(CGPointEqualToPoint(_startup.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + _startup.frame.size.height - _setNumberVariable1.configuration.heightOfPlugCenter + translation.y)), @"");
    
    [_startup putDownAllNextBlocks];
    XCTAssertEqual(_startup.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");
}

- (void)testAttachTwoStatement {
    XCTAssertEqual(_startup.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, NO, @"");
    
    [_startup attachStatement:_setNumberVariable1 toSocket:0];
    [_startup attachStatement:_setNumberVariable2 toSocket:0];
    [_startup pickUpAllNextBlocks];
    XCTAssertEqual(_startup.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, YES, @"");
    
    CGPoint translation = CGPointMake(10.0, 10.0);
    [_startup moveAllNextBlocksByTranslation:translation];
    XCTAssertTrue(CGPointEqualToPoint(_startup.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + _startup.frame.size.height - _startup.configuration.heightOfPlugCenter + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + _startup.frame.size.height + _setNumberVariable1.frame.size.height - _startup.configuration.heightOfPlugCenter * 2 + translation.y)), @"");
    
    [_startup putDownAllNextBlocks];
    XCTAssertEqual(_startup.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, NO, @"");
}

- (void)testAttachTwoStatementsIntoTwoStatements {
    XCTAssertEqual(_startup.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable3.isPickedUp, NO, @"");
    
    [_startup attachStatement:_setNumberVariable3 toSocket:0];
    [_setNumberVariable1 attachStatement:_setNumberVariable2 toSocket:0];
    [_startup attachStatement:_setNumberVariable1 toSocket:0];
    
    [_startup pickUpAllNextBlocks];
    XCTAssertEqual(_startup.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable3.isPickedUp, YES, @"");
    
    CGPoint translation = CGPointMake(10.0, 10.0);
    [_startup moveAllNextBlocksByTranslation:translation];
    XCTAssertTrue(CGPointEqualToPoint(_startup.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + _startup.frame.size.height - _startup.configuration.heightOfPlugCenter + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + _startup.frame.size.height + _setNumberVariable1.frame.size.height - _startup.configuration.heightOfPlugCenter * 2 + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable3.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + _startup.frame.size.height + _setNumberVariable1.frame.size.height + _setNumberVariable2.frame.size.height - _startup.configuration.heightOfPlugCenter * 3 + translation.y)), @"");
    
    [_startup putDownAllNextBlocks];
    XCTAssertEqual(_startup.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable3.isPickedUp, NO, @"");
}

- (void)testDetach {
    [_startup attachStatement:_setNumberVariable3 toSocket:0];
    [_setNumberVariable1 attachStatement:_setNumberVariable2 toSocket:0];
    [_startup attachStatement:_setNumberVariable1 toSocket:0];
    
    [_setNumberVariable2 detachFromOtherBlock];

    XCTAssertEqual(_startup.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable3.isPickedUp, NO, @"");

    [_startup pickUpAllNextBlocks];
    XCTAssertEqual(_startup.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable3.isPickedUp, NO, @"");
    
    CGPoint translation = CGPointMake(10.0, 10.0);
    [_startup moveAllNextBlocksByTranslation:translation];
    XCTAssertTrue(CGPointEqualToPoint(_startup.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, CGPointMake(_originOfStartup.x + translation.x, _originOfStartup.y + _startup.frame.size.height - _startup.configuration.heightOfPlugCenter + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake(_originOfStartup.x, _originOfStartup.y + _startup.frame.size.height + _setNumberVariable1.frame.size.height - _startup.configuration.heightOfPlugCenter * 2)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable3.frame.origin, CGPointMake(_originOfStartup.x, _originOfStartup.y + _startup.frame.size.height +_setNumberVariable1.frame.size.height + _setNumberVariable2.frame.size.height - _startup.configuration.heightOfPlugCenter * 3)), @"");
}

@end
