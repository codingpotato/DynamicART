//
//  CPBlockTests.m
//  DynamicArt
//
//  Created by 咏武 王 on 3/8/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlockTests.h"

#import "CPGeometryHelper.h"

#import "CPAdd.h"
#import "CPArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"

@implementation CPBlockTests

- (void)setUp {
    [super setUp];
    
    _blockController = [[CPBlockController alloc] init];
    
    _originOfAdd1 = CGPointMake(100.0, 100.0);
    _add1 = (CPAdd *)[_blockController createBlockOfClass:[CPAdd class] atOrigin:_originOfAdd1];
    _originOfAdd2 = CGPointMake(200.0, 200.0);
    _add2 = (CPAdd *)[_blockController createBlockOfClass:[CPAdd class] atOrigin:_originOfAdd2];
}

- (void)tearDown {
    _add1 = nil;
    _add2 = nil;
    
    [super tearDown];
}

- (void)testInit {
    XCTAssertTrue(CGPointEqualToPoint(_add1.frame.origin, _originOfAdd1), @"");
    XCTAssertFalse(_add1.pickedUp, @"");
    XCTAssertFalse(_add1.removed, @"");
}

- (void)testConfiguration {
    XCTAssertNotNil(_add1.configuration, @"");
    XCTAssertEqual(_add1.configuration.blockClass, [CPAdd class], @"");
    XCTAssertEqual(_add1.configuration.color, CPBlockConfigurationColorNone, @"");
    XCTAssertEqual(_add1.configuration.numberOfSockets, 0, @"");
    CPBlockConfiguration *configuration1 = _add1.configuration;
    CPBlockConfiguration *configuration2 = _add1.configuration;
    XCTAssertEqual(configuration1, configuration2, @"");
}

- (void)testSyntaxOrderArguments {
    XCTAssertEqual(_add1.syntaxOrderArguments.count, _add1.configuration.syntaxArgumentClasses.count, @"");
}

- (void)testDisplayOrderArguments {
    XCTAssertEqual(_add1.displayOrderArguments.count, (NSUInteger)3, @"");
}

- (void)testIndexOfArgumentConnectedToExpression {
    CPArgument *argument1 = [_add1.syntaxOrderArguments objectAtIndex:0];
    CPArgument *argument2 = [_add1.syntaxOrderArguments objectAtIndex:1];
    XCTAssertNil([_add1 argumentConnectedTo:_add2], @"");
    
    CGPoint translation = CGPointMake(_originOfAdd1.x - _originOfAdd2.x, _originOfAdd1.y - _originOfAdd2.y);
    [_add2 pickUp];
    [_add2 moveByTranslation:translation];
    XCTAssertEqual([_add1 argumentConnectedTo:_add2], argument1, @"");
    
    translation = CGPointMake(argument2.frame.origin.x - argument1.frame.origin.x, 0.0);
    [_add2 moveByTranslation:translation];
    XCTAssertEqual([_add1 argumentConnectedTo:_add2], argument2, @"");
}

- (void)testChangeArgumentWidth {
    CPArgument *argument1 = [_add1.displayOrderArguments objectAtIndex:0];
    CPArgument *argument2 = [_add1.displayOrderArguments objectAtIndex:1];

    CGFloat deltaWidth = 10.0;
    CGFloat deltaHeight = 0.0;    
    CGRect expectedArgument1Frame = CPRectIncreaseSize(argument1.frame, CGSizeMake(deltaWidth, deltaHeight));
    CGRect expectedArgument2Frame = CPRectTranslate(argument2.frame, CGPointMake(deltaWidth, 0.0));
    CGRect expectedAdd1Frame = CPRectIncreaseSize(_add1.frame, CGSizeMake(deltaWidth, deltaHeight));
    
    CGSize size = argument1.frame.size;
    size.width += deltaWidth;
    size.height += deltaHeight;
    [argument1 setSize:size notifyParentBlock:YES];
    
    XCTAssertTrue(CGRectEqualToRect(argument1.frame, expectedArgument1Frame), @"");
    XCTAssertTrue(CGRectEqualToRect(argument2.frame, expectedArgument2Frame), @"");
    XCTAssertTrue(CGRectEqualToRect(_add1.frame, expectedAdd1Frame), @"");
}

- (void)testChangeArgumentSize {
    CPArgument *argument1 = [_add1.displayOrderArguments objectAtIndex:0];
    CPArgument *argument2 = [_add1.displayOrderArguments objectAtIndex:1];
    
    CGFloat deltaWidth = 10.0;
    CGFloat deltaHeight = 20.0;
    
    CGRect expectedArgument1Frame = CPRectIncreaseSize(argument1.frame, CGSizeMake(deltaWidth, deltaHeight));
    CGRect expectedArgument2Frame = CPRectTranslate(argument2.frame, CGPointMake(deltaWidth, deltaHeight / 2));
    CGRect expectedAdd1Frame = CPRectIncreaseSize(_add1.frame, CGSizeMake(deltaWidth, deltaHeight));
    
    CGSize size = argument1.frame.size;
    size.width += deltaWidth;
    size.height += deltaHeight;
    [argument1 setSize:size notifyParentBlock:YES];
    
    XCTAssertTrue(CPRectEqualToRect(argument1.frame, expectedArgument1Frame), @"");
    XCTAssertTrue(CPRectEqualToRect(argument2.frame, expectedArgument2Frame), @"");
    XCTAssertTrue(CPRectEqualToRect(_add1.frame, expectedAdd1Frame), @"");
}

@end
