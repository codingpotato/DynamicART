//
//  CPArgumentTests.m
//  DynamicArt
//
//  Created by 咏武 王 on 3/12/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPArgumentTests.h"

#import "CPGeometryHelper.h"

#import "CPBlockController.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPNumberValue.h"
#import "CPStatementMockup.h"
#import "CPSub.h"

@implementation CPArgumentTests

- (void)setUp {
    [super setUp];
 
    _blockController = [[CPBlockController alloc] init];
    
    _parentBlock = [[CPStatementMockup alloc] init];
    _parentBlock.blockController = _blockController;
    
    _argument = [[CPRightValueWeakTypeArgument alloc] initWithValue:[CPNumberValue valueWithDouble:0.0]];
    _argument.parentBlock = _parentBlock;
    [_argument didAddIntoParentBlock];
    
    _sub = (CPSub *)[_blockController createBlockOfClass:[CPSub class] atOrigin:CGPointMake(300.0, 300.0)];
}

- (void)tearDown {
    _blockController = nil;
    _parentBlock = nil;
    _argument = nil;
    _sub = nil;

    [super tearDown];    
}

- (void)testSetOrigin {
    CGPoint expectedOrigin = CGPointMake(10.0, 10.0);
    [_argument setOrigin:expectedOrigin];
    XCTAssertTrue(CGPointEqualToPoint(_argument.frame.origin, expectedOrigin), @"");
}

- (void)testSetSize {
    CGFloat deltaWidth = 20.0;
    CGSize size = _argument.frame.size;
    size.width += deltaWidth;
    
    _parentBlock.sizeChangedArgument = nil;
    _parentBlock.deltaSizeOfArgument = CGSizeZero;
    [_argument setSize:size notifyParentBlock:YES];
    XCTAssertTrue(CGPointEqualToPoint(_argument.frame.origin, CGPointZero), @"");
    XCTAssertTrue(CGSizeEqualToSize(_argument.frame.size, size), @"");
    XCTAssertEqual(_parentBlock.sizeChangedArgument, _argument, @"");
    XCTAssertTrue(CGSizeEqualToSize(_parentBlock.deltaSizeOfArgument, CGSizeMake(deltaWidth, 0.0)), @"");
}

- (void)testNearExpression {
    XCTAssertNil([_argument argumentNearToExpression:_sub], @"");
    XCTAssertFalse(_argument.connectedToExpression, @"");

    CGPoint translation = CGPointMake(_argument.frame.origin.x + _parentBlock.frame.origin.x - _sub.frame.origin.x, _argument.frame.origin.y + _parentBlock.frame.origin.y - _sub.frame.origin.y);
    [_sub pickUp];
    [_sub moveByTranslation:translation];
    XCTAssertEqual([_argument argumentNearToExpression:_sub], _argument, @"");
    XCTAssertTrue(_argument.connectedToExpression, @"");
}

- (void)testAttachAndDetachExpression {
    CGRect oldRightValueArgumentFrame = _argument.frame;
    CGSize expectedDeltaSizeOfArgument = CGSizeMake(_sub.frame.size.width - oldRightValueArgumentFrame.size.width, _sub.frame.size.height - oldRightValueArgumentFrame.size.height);
    _parentBlock.sizeChangedArgument = nil;
    _parentBlock.deltaSizeOfArgument = CGSizeZero;    
    [_argument attachExpression:_sub];

    XCTAssertEqual(_sub.parentArgument, _argument, @"");
    XCTAssertEqual(_parentBlock.sizeChangedArgument, _argument, @"");
    XCTAssertTrue(CGSizeEqualToSize(_parentBlock.deltaSizeOfArgument, expectedDeltaSizeOfArgument), @"");
    XCTAssertTrue(CGRectEqualToRect(_argument.frame, CGRectMake(oldRightValueArgumentFrame.origin.x, oldRightValueArgumentFrame.origin.y, _sub.frame.size.width, _sub.frame.size.height)), @"");
    XCTAssertTrue(CGPointEqualToPoint(_sub.frame.origin, CPPointTranslate(_argument.frame.origin, _parentBlock.frame.origin)), @"");
    
    [_argument pickUpExpression];
    XCTAssertTrue(_sub.isPickedUp, @"");
    [_argument putDownExpression];

    expectedDeltaSizeOfArgument.width *= -1;
    expectedDeltaSizeOfArgument.height *= -1;
    _parentBlock.sizeChangedArgument = nil;
    _parentBlock.deltaSizeOfArgument = CGSizeZero;
    [_argument detachExpression];
    
    XCTAssertNil(_sub.parentArgument, @"");
    XCTAssertEqual(_parentBlock.sizeChangedArgument, _argument, @"");
    XCTAssertTrue(CGSizeEqualToSize(_parentBlock.deltaSizeOfArgument, expectedDeltaSizeOfArgument), @"");
    XCTAssertTrue(CGRectEqualToRect(_argument.frame, oldRightValueArgumentFrame), @"");
    XCTAssertTrue(CGPointEqualToPoint(_sub.frame.origin, CPPointTranslate(_argument.frame.origin, _parentBlock.frame.origin)), @"");

    [_argument pickUpExpression];
    XCTAssertFalse(_sub.isPickedUp, @"");
}

@end
