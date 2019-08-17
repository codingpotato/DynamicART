//
//  CPLoopTests.m
//  DynamicTests
//
//  Created by wangyw on 12-3-1.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPRepeatTests.h"

#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPRepeat.h"
#import "CPSetVariable.h"

@implementation CPRepeatTests

- (void)setUp {
    [super setUp];
    
    _originOfRepeat = CGPointMake(100.0, 10.0);
    _repeat = [[CPRepeat alloc] initAtOrigin:_originOfRepeat];

    _originOfSetNumberVariable1 = CGPointMake(100.0, 210.0);
    _setNumberVariable1 = [[CPSetVariable alloc] initAtOrigin:_originOfSetNumberVariable1];

    _originOfSetNumberVariable2 = CGPointMake(100.0, 410.0);
    _setNumberVariable2 = [[CPSetVariable alloc] initAtOrigin:_originOfSetNumberVariable1];
    
    _originOfSetNumberVariable3 = CGPointMake(100.0, 610.0);
    _setNumberVariable3 = [[CPSetVariable alloc] initAtOrigin:_originOfSetNumberVariable1];
    
    _originOfSetNumberVariable4 = CGPointMake(300.0, 10.0);
    _setNumberVariable4 = [[CPSetVariable alloc] initAtOrigin:_originOfSetNumberVariable1];
}

- (void)tearDown {
    _repeat = nil;
    _setNumberVariable1 = nil;
    _setNumberVariable2 = nil;
    _setNumberVariable3 = nil;
    _setNumberVariable4 = nil;
    
    [super tearDown];
}

- (void)testAttachOneStatementForEachSocket {
    CGPoint centerOfSocket0 = [_repeat centerOfSocketAtIndex:0];
    CGPoint centerOfSocket1 = [_repeat centerOfSocketAtIndex:1];    
    CGSize sizeOfRepeat = _repeat.frame.size;
    
    XCTAssertEqual(_repeat.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, NO, @"");
    
    [_repeat attachStatement:_setNumberVariable1 toSocket:0];
    [_repeat attachStatement:_setNumberVariable2 toSocket:1];

    XCTAssertTrue(CGSizeEqualToSize(_repeat.frame.size, CGSizeMake(sizeOfRepeat.width, sizeOfRepeat.height + _setNumberVariable1.frame.size.height - _setNumberVariable1.configuration.heightOfPlugCenter - _repeat.configuration.heightOfInnerSpace)), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:0], centerOfSocket0), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:1], CGPointMake(centerOfSocket1.x, centerOfSocket1.y + _setNumberVariable1.frame.size.height - _setNumberVariable1.configuration.heightOfPlugCenter - _repeat.configuration.heightOfInnerSpace)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:0].y - _repeat.configuration.heightOfPlugCenter)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:1].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:1].y - _repeat.configuration.heightOfPlugCenter)), @"");

    [_repeat pickUpAllNextBlocks];
    CGPoint translation = CGPointMake(20.0, 10.0);
    [_repeat moveAllNextBlocksByTranslation:translation];
    
    XCTAssertTrue(CGSizeEqualToSize(_repeat.frame.size, CGSizeMake(sizeOfRepeat.width, sizeOfRepeat.height + _setNumberVariable1.frame.size.height - _setNumberVariable1.configuration.heightOfPlugCenter - _repeat.configuration.heightOfInnerSpace)), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:0], CGPointMake(centerOfSocket0.x + translation.x, centerOfSocket0.y + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:1], CGPointMake(centerOfSocket1.x + translation.x, centerOfSocket1.y + _setNumberVariable1.frame.size.height + translation.y - _setNumberVariable1.configuration.heightOfPlugCenter - _repeat.configuration.heightOfInnerSpace)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:0].y - _repeat.configuration.heightOfPlugCenter)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:1].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:1].y - _repeat.configuration.heightOfPlugCenter)), @"");

    XCTAssertEqual(_repeat.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, YES, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, YES, @"");

    [_repeat putDownAllNextBlocks];
    XCTAssertEqual(_repeat.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable1.isPickedUp, NO, @"");
    XCTAssertEqual(_setNumberVariable2.isPickedUp, NO, @"");
}

- (void)testDetach {
    CGPoint centerOfSocket0 = [_repeat centerOfSocketAtIndex:0];
    CGPoint centerOfSocket1 = [_repeat centerOfSocketAtIndex:1];
    CGSize sizeOfRepeat = _repeat.frame.size;
    
    [_repeat attachStatement:_setNumberVariable1 toSocket:0];
    [_repeat attachStatement:_setNumberVariable2 toSocket:1];    
    [_setNumberVariable1 detachFromOtherBlock];
    
    [_repeat pickUpAllNextBlocks];
    CGPoint translation = CGPointMake(20.0, 10.0);
    [_repeat moveAllNextBlocksByTranslation:translation];
    
    XCTAssertTrue(CGSizeEqualToSize(_repeat.frame.size, CGSizeMake(sizeOfRepeat.width, sizeOfRepeat.height)), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:0], CGPointMake(centerOfSocket0.x + translation.x, centerOfSocket0.y + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:1], CGPointMake(centerOfSocket1.x + translation.x, centerOfSocket1.y + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter - translation.x, [_repeat centerOfSocketAtIndex:0].y - _repeat.configuration.heightOfPlugCenter - translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:1].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:1].y - _repeat.configuration.heightOfPlugCenter)), @"");
}

- (void)testAttachTwoStatementsForEachSocket {
    CGPoint centerOfSocket0 = [_repeat centerOfSocketAtIndex:0];
    CGPoint centerOfSocket1 = [_repeat centerOfSocketAtIndex:1];
    CGSize sizeOfRepeat = _repeat.frame.size;
    
    [_repeat attachStatement:_setNumberVariable1 toSocket:0];
    [_setNumberVariable1 attachStatement:_setNumberVariable2 toSocket:0];
    [_repeat attachStatement:_setNumberVariable3 toSocket:1];
    [_setNumberVariable3 attachStatement:_setNumberVariable4 toSocket:0];
    
    [_repeat pickUpAllNextBlocks];
    CGPoint translation = CGPointMake(20.0, 10.0);
    [_repeat moveAllNextBlocksByTranslation:translation];
    
    XCTAssertTrue(CGSizeEqualToSize(_repeat.frame.size, CGSizeMake(sizeOfRepeat.width, sizeOfRepeat.height + _setNumberVariable1.frame.size.height - _setNumberVariable1.configuration.heightOfPlugCenter + _setNumberVariable2.frame.size.height - _setNumberVariable1.configuration.heightOfPlugCenter - _repeat.configuration.heightOfInnerSpace)), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:0], CGPointMake(centerOfSocket0.x + translation.x, centerOfSocket0.y + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:1], CGPointMake(centerOfSocket1.x + translation.x, centerOfSocket1.y + _setNumberVariable1.frame.size.height -_setNumberVariable1.configuration.heightOfPlugCenter + _setNumberVariable2.frame.size.height -_setNumberVariable2.configuration.heightOfPlugCenter - _repeat.configuration.heightOfInnerSpace + translation.y)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable1.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:0].y - _repeat.configuration.heightOfPlugCenter)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:0].y + _setNumberVariable1.frame.size.height - _repeat.configuration.heightOfPlugCenter * 2)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable3.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:1].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:1].y - _repeat.configuration.heightOfPlugCenter)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable4.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:1].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:1].y + _setNumberVariable1.frame.size.height - _repeat.configuration.heightOfPlugCenter * 2)), @"");

    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake([_setNumberVariable1 centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter, [_setNumberVariable1 centerOfSocketAtIndex:0].y - _repeat.configuration.heightOfPlugCenter)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable4.frame.origin, CGPointMake([_setNumberVariable3 centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter, [_setNumberVariable3 centerOfSocketAtIndex:0].y - _repeat.configuration.heightOfPlugCenter)), @"");
}

- (void)testAttachLoopNextToOtherBlock {
    CGPoint centerOfSocket0 = [_repeat centerOfSocketAtIndex:0];
    CGPoint centerOfSocket1 = [_repeat centerOfSocketAtIndex:1];
    CGSize sizeOfRepeat = _repeat.frame.size;
    CGRect expectedSetNumberVariable1Frame = _setNumberVariable1.frame;
    
    [_repeat attachStatement:_setNumberVariable2 toSocket:0];
    [_repeat attachStatement:_setNumberVariable3 toSocket:1];
    [_setNumberVariable1 attachStatement:_repeat toSocket:0];

    XCTAssertTrue(CGRectEqualToRect(_setNumberVariable1.frame, expectedSetNumberVariable1Frame), @"");
    XCTAssertTrue(CGPointEqualToPoint(_repeat.frame.origin, CGPointMake([_setNumberVariable1 centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter, [_setNumberVariable1 centerOfSocketAtIndex:0].y - _repeat.configuration.heightOfPlugCenter)), @"");
    XCTAssertTrue(CGSizeEqualToSize(_repeat.frame.size, CGSizeMake(sizeOfRepeat.width, sizeOfRepeat.height + _setNumberVariable2.frame.size.height - _setNumberVariable2.configuration.heightOfPlugCenter - _repeat.configuration.heightOfInnerSpace)), @"");
    
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:0], CGPointMake([_setNumberVariable1 centerOfSocketAtIndex:0].x + _repeat.configuration.widthOfLeftBar, [_setNumberVariable1 centerOfSocketAtIndex:0].y + centerOfSocket0.y - _originOfRepeat.y - _repeat.configuration.heightOfPlugCenter)), @"");
    XCTAssertTrue(CGPointEqualToPoint([_repeat centerOfSocketAtIndex:1], CGPointMake([_setNumberVariable1 centerOfSocketAtIndex:0].x, [_setNumberVariable1 centerOfSocketAtIndex:0].y - _setNumberVariable1.configuration.heightOfPlugCenter + centerOfSocket1.y - _originOfRepeat.y + _setNumberVariable1.frame.size.height - _setNumberVariable1.configuration.heightOfPlugCenter - _repeat.configuration.heightOfInnerSpace)), @"");
    
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable2.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:0].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:0].y - _repeat.configuration.heightOfPlugCenter)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_setNumberVariable3.frame.origin, CGPointMake([_repeat centerOfSocketAtIndex:1].x - _repeat.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:1].y - _repeat.configuration.heightOfPlugCenter)), @"");
}

@end
