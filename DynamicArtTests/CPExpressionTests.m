//
//  CPExpressionTests.m
//  DynamicArt
//
//  Created by 咏武 王 on 3/8/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPExpressionTests.h"

#import "CPGeometryHelper.h"

#import "CPAdd.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPLeftValueArgument.h"
#import "CPRepeat.h"
#import "CPPromptArgument.h"
#import "CPRightValueWeakTypeArgument.h"
#import "CPSetVariable.h"

@implementation CPExpressionTests

- (void)setUp {
    [super setUp];
    
    _blockController = [[CPBlockController alloc] init];
    
    _originOfSetVariable = CGPointMake(100.0, 10.0);
    _setVariable = (CPSetVariable *)[_blockController createBlockOfClass:[CPSetVariable class] atOrigin:_originOfSetVariable];
    
    _originOfAdd1 = CGPointMake(200.0, 200.0);
    _add1 = (CPAdd *)[_blockController createBlockOfClass:[CPAdd class] atOrigin:_originOfAdd1];

    _originOfAdd2 = CGPointMake(300.0, 300.0);
    _add2 = (CPAdd *)[_blockController createBlockOfClass:[CPAdd class] atOrigin:_originOfAdd2];

    _originOfRepeat = CGPointMake(400.0, 400.0);
    _repeat = (CPRepeat *)[_blockController createBlockOfClass:[CPRepeat class] atOrigin:_originOfRepeat];
}

- (void)tearDown {
    _blockController = nil;
    _setVariable = nil;
    _add1 = nil;
    _add2 = nil;
    _repeat = nil;
    
    [super tearDown];
}

- (void)testInit {
    XCTAssertEqual(_setVariable.syntaxOrderArguments.count, (NSUInteger)2, @"");
    XCTAssertTrue([[_setVariable.syntaxOrderArguments objectAtIndex:0] isKindOfClass:[CPLeftValueArgument class]], @"");
    XCTAssertTrue([[_setVariable.syntaxOrderArguments objectAtIndex:1] isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");
    XCTAssertEqual(_setVariable.displayOrderArguments.count, (NSUInteger)4, @"");
    XCTAssertTrue([[_setVariable.displayOrderArguments objectAtIndex:0] isKindOfClass:[CPPromptArgument class]], @"");
    XCTAssertTrue([[_setVariable.displayOrderArguments objectAtIndex:1] isKindOfClass:[CPLeftValueArgument class]], @"");
    XCTAssertTrue([[_setVariable.displayOrderArguments objectAtIndex:2] isKindOfClass:[CPPromptArgument class]], @"");
    XCTAssertTrue([[_setVariable.displayOrderArguments objectAtIndex:3] isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");

    XCTAssertEqual(_repeat.syntaxOrderArguments.count, (NSUInteger)1, @"");
    XCTAssertTrue([[_repeat.syntaxOrderArguments objectAtIndex:0] isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");
    XCTAssertEqual(_repeat.displayOrderArguments.count, (NSUInteger)3, @"");
    XCTAssertTrue([[_repeat.displayOrderArguments objectAtIndex:0] isKindOfClass:[CPPromptArgument class]], @"");
    XCTAssertTrue([[_repeat.displayOrderArguments objectAtIndex:1] isKindOfClass:[CPRightValueWeakTypeArgument class]], @"");
    XCTAssertTrue([[_repeat.displayOrderArguments objectAtIndex:2] isKindOfClass:[CPPromptArgument class]], @"");
}

- (void)testAttachOneExpresssion {
    CPArgument *argument = [_setVariable.syntaxOrderArguments objectAtIndex:1];

    XCTAssertEqual(_setVariable.isPickedUp, NO, @"");
    XCTAssertEqual(_add1.isPickedUp, NO, @"");
    
    CGRect expectedVariableSetterFrame = CGRectMake(_originOfSetVariable.x, _originOfSetVariable.y, _setVariable.frame.size.width + _add1.frame.size.width - argument.frame.size.width, _setVariable.frame.size.height + _add1.frame.size.height - argument.frame.size.height);
    
    [argument attachExpression:_add1];
    [_blockController pickUpBlocksFrom:_setVariable];
    XCTAssertEqual(_setVariable.isPickedUp, YES, @"");
    XCTAssertEqual(_add1.isPickedUp, YES, @"");
    
    XCTAssertTrue(CGPointEqualToPoint(_add1.frame.origin, CGPointMake(_originOfSetVariable.x + argument.frame.origin.x, _originOfSetVariable.y + argument.frame.origin.y)), @"");
    XCTAssertTrue(CGRectEqualToRect(_setVariable.frame, expectedVariableSetterFrame), @"");
    XCTAssertTrue(CGRectEqualToRect(argument.frame, CPRectTranslate(_add1.frame, CGPointMake(-_setVariable.frame.origin.x, -_setVariable.frame.origin.y))), @"");
    
    CGPoint translation = CGPointMake(20.0, 10.0);
    expectedVariableSetterFrame.origin.x += translation.x;
    expectedVariableSetterFrame.origin.y += translation.y;
    [_blockController moveBlocksFrom:_setVariable byTranslation:translation];
    XCTAssertTrue(CGPointEqualToPoint(_add1.frame.origin, CGPointMake(_originOfSetVariable.x + argument.frame.origin.x + translation.x, _originOfSetVariable.y + argument.frame.origin.y + translation.y)), @"");
    XCTAssertTrue(CGRectEqualToRect(_setVariable.frame, expectedVariableSetterFrame), @"");

    [_blockController putDownBlocksFrom:_setVariable];
    XCTAssertEqual(_setVariable.isPickedUp, NO, @"");
    XCTAssertEqual(_add1.isPickedUp, NO, @"");
}

- (void)testAttachTwoExpresssion {
    CPArgument *variableSetterArgument2 = [_setVariable.syntaxOrderArguments objectAtIndex:1];
    CPArgument *add1Argument1 = [_add1.syntaxOrderArguments objectAtIndex:0];

    XCTAssertEqual(_setVariable.isPickedUp, NO, @"");
    XCTAssertEqual(_add1.isPickedUp, NO, @"");
    XCTAssertEqual(_add2.isPickedUp, NO, @"");
    
    CGSize expectedAdd1Size = CGSizeMake(_add1.frame.size.width + _add2.frame.size.width  - variableSetterArgument2.frame.size.width, _add1.frame.size.height + _add2.frame.size.height - variableSetterArgument2.frame.size.height);
    CGSize expectedAdd2Size = _add2.frame.size;
    CGRect expectedVariableSetterFrame = CGRectMake(_originOfSetVariable.x, _originOfSetVariable.y, _setVariable.frame.size.width + _add1.frame.size.width + _add2.frame.size.width - add1Argument1.frame.size.width - variableSetterArgument2.frame.size.width, _setVariable.frame.size.height + _add1.frame.size.height + _add2.frame.size.height - add1Argument1.frame.size.height * 2);
    
    [variableSetterArgument2 attachExpression:_add1];
    [add1Argument1 attachExpression:_add2];
    
    [_blockController pickUpBlocksFrom:_setVariable];
    XCTAssertEqual(_setVariable.isPickedUp, YES, @"");
    XCTAssertEqual(_add1.isPickedUp, YES, @"");
    XCTAssertEqual(_add2.isPickedUp, YES, @"");
    
    XCTAssertTrue(CGPointEqualToPoint(_add1.frame.origin, CPPointTranslate(_originOfSetVariable, variableSetterArgument2.frame.origin)), @"");
    XCTAssertTrue(CGSizeEqualToSize(_add1.frame.size, expectedAdd1Size), @"");
    XCTAssertTrue(CGPointEqualToPoint(_add2.frame.origin, CPPointTranslate(add1Argument1.frame.origin, _add1.frame.origin)), @"");
    XCTAssertTrue(CGSizeEqualToSize(_add2.frame.size, expectedAdd2Size), @"");
    XCTAssertTrue(CGRectEqualToRect(_setVariable.frame, expectedVariableSetterFrame), @"");
    
    CGPoint translation = CGPointMake(10.0, 10.0);
    [_blockController moveBlocksFrom:_setVariable byTranslation:translation];
    XCTAssertTrue(CGPointEqualToPoint(_add1.frame.origin, CGPointMake(_originOfSetVariable.x + variableSetterArgument2.frame.origin.x + translation.x, _originOfSetVariable.y + variableSetterArgument2.frame.origin.y + translation.y)), @"");
    expectedVariableSetterFrame.origin.x += translation.x;
    expectedVariableSetterFrame.origin.y += translation.y;
    XCTAssertTrue(CGRectEqualToRect(_setVariable.frame, expectedVariableSetterFrame), @"");
    
    translation.x *= -1;
    translation.y *= -1;
    [_blockController moveBlocksFrom:_setVariable byTranslation:translation];    
    
    [_blockController putDownBlocksFrom:_setVariable];
    XCTAssertEqual(_setVariable.isPickedUp, NO, @"");
    XCTAssertEqual(_add1.isPickedUp, NO, @"");
    XCTAssertEqual(_add2.isPickedUp, NO, @"");
}

- (void)testAttachBlockWithExpression {
    CPArgument *argument = [_setVariable.syntaxOrderArguments objectAtIndex:1];

    CGRect expectedVariableSetterFrame = CGRectMake([_repeat centerOfSocketAtIndex:1].x - _setVariable.configuration.leftOfPlugCenter, [_repeat centerOfSocketAtIndex:1].y - _setVariable.configuration.heightOfPlugCenter, _setVariable.frame.size.width + _add1.frame.size.width - argument.frame.size.width, _setVariable.frame.size.height + _add1.frame.size.height - argument.frame.size.height);
    
    [argument attachExpression:_add1];
    [_repeat attachStatement:_setVariable toSocket:1];
    XCTAssertTrue(CGRectEqualToRect(_setVariable.frame, expectedVariableSetterFrame), @"");
    XCTAssertTrue(CGPointEqualToPoint(_add1.frame.origin, CGPointMake(_setVariable.frame.origin.x + argument.frame.origin.x, _setVariable.frame.origin.y + argument.frame.origin.y)), @"");
}

@end
