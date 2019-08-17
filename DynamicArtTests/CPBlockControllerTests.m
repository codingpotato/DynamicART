//
//  CPBlockBoardTests.m
//  DynamicTests
//
//  Created by 咏武 王 on 12-2-29.
//  Copyright (c) 2012年 codingpotato. All rights reserved.
//

#import "CPBlockControllerTests.h"

#import "CPGeometryHelper.h"

#import "CPAdd.h"
#import "CPArgument.h"
#import "CPBlockController.h"
#import "CPStartup.h"
#import "CPSetVariable.h"

@implementation CPBlockControllerTests

- (void)setUp {
    [super setUp];
    
    _blockController = [[CPBlockController alloc] init];
    
    _originOfSetNumberVariable = CGPointMake(100.0, 10.0);
    _setNumberVariable = (CPSetVariable *)[_blockController createBlockOfClass:[CPSetVariable class] atOrigin:_originOfSetNumberVariable];
    
    _originOfStartup = CGPointMake(100.0, 70.0);
    _startup = (CPStartup *)[_blockController createBlockOfClass:[CPSetVariable class] atOrigin:_originOfStartup];
    
    _originOfAdd = CGPointMake(200.0, 200.0);
    _add = (CPAdd *)[_blockController createBlockOfClass:[CPAdd class] atOrigin:_originOfAdd];
}

- (void)tearDown {
    _blockController = nil;
    _setNumberVariable = nil;
    _startup = nil;
    _add = nil;
    
    [super tearDown];    
}

- (void)testMoveAndConnectPlugAndSocket {
    XCTAssertEqual(_blockController.plugAndSocketConnected, NO, @"");

    CGPoint translation = CGPointMake(_originOfStartup.x - _originOfSetNumberVariable.x, _originOfStartup.y + _startup.frame.size.height - _originOfSetNumberVariable.y);
    [_blockController pickUpBlocksFrom:_setNumberVariable];
    [_blockController moveBlocksFrom:_setNumberVariable byTranslation:translation];
    XCTAssertEqual(_blockController.plugAndSocketConnected, YES, @"");

    translation.x += -1;
    translation.y *= -1;
    [_blockController moveBlocksFrom:_setNumberVariable byTranslation:translation];
    XCTAssertEqual(_blockController.plugAndSocketConnected, NO, @"");
}

- (void)testMoveAndConnectArgumentAndExpression {
    CPArgument *argument = [_setNumberVariable.syntaxOrderArguments objectAtIndex:1];
    
    CGPoint translation = CGPointMake(argument.frame.origin.x + _originOfSetNumberVariable.x - _originOfAdd.x, argument.frame.origin.y + _originOfSetNumberVariable.y - _originOfAdd.y);
    [_blockController pickUpBlocksFrom:_add];
    [_blockController moveBlocksFrom:_add byTranslation:translation];
    XCTAssertTrue(argument.connectedToExpression, @"");

    translation.x += -1;
    translation.y *= -1;
    [_blockController moveBlocksFrom:_add byTranslation:translation];
    XCTAssertFalse(argument.connectedToExpression, @"");
}

@end
