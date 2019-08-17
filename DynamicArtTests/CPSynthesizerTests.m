//
//  CPSynthesizerTests.m
//  DynamicArtTests
//
//  Created by wangyw on 8/11/12.
//  Copyright (c) 2012 wangyw. All rights reserved.
//

#import "CPSynthesizerTests.h"

#import "CPSynthesizer.h"

@interface CPSynthesizerTests ()

@property (strong, nonatomic) CPSynthesizer *synthesizer;

@end

@implementation CPSynthesizerTests

- (void)setUp {
    [super setUp];
    
    self.synthesizer = [[CPSynthesizer alloc] init];
}

- (void)tearDown {
    self.synthesizer = nil;
    
    [super tearDown];
}

- (void)testAddNoteString {
    [self.synthesizer performSelector:@selector(addNoteString:) withObject:@"C1"];
    NSMutableArray *notes = [self.synthesizer performSelector:@selector(notes) withObject:nil];
    XCTAssertEqual(notes.count, (NSUInteger)2, @"");
    XCTAssertEqual(((NSNumber *)[notes objectAtIndex:0]).intValue, 40, @"");
    XCTAssertEqual(((NSNumber *)[notes objectAtIndex:1]).floatValue, 2.0f, @"");
}

@end
