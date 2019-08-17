//
//  CPDisplayCommand.m
//  DynamicArt
//
//  Created by wangyw on 3/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPWriteCommand.h"

#import "CPDrawContext.h"

@implementation CPWriteCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextSaveGState(drawContext.context);
    
    UIFont *font = [UIFont fontWithName:drawContext.fontName size:drawContext.fontSize];
    if (self.isPositionCenter) {
        CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName: font}];
        _position.x -= size.width / 2;
        _position.y -= size.height / 2;
    }
    [self.text drawAtPoint:self.position withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: drawContext.lineColor}];
    
    CGContextRestoreGState(drawContext.context);
}

@end
