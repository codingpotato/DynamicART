//
//  CPPointCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/26/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPPointCommand.h"

#import "CPCOlorValue.h"
#import "CPDrawContext.h"

@implementation CPPointCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    size_t width = CGBitmapContextGetWidth(context);
    size_t height = CGBitmapContextGetHeight(context);
    int scale = width / drawContext.size.width;
    if (drawContext.lineWidth <= 1.0 / scale) {
        // fast point draw
        self.position = CGPointMake(self.position.x * scale, self.position.y * scale);
        if (self.position.x >= 0 && self.position.x < width && self.position.y >= 0 && self.position.y < height) {
            size_t bytesPerPixel = CGBitmapContextGetBitsPerPixel(context) / 8;
            CGBitmapInfo bitmapInfo = CGBitmapContextGetBitmapInfo(context);
            
            int index = (round(self.position.y) * width + round(self.position.x)) * bytesPerPixel;
            
            CGFloat pointRed, pointGreen, pointBlue, pointAlpha;
            [drawContext.lineColor getRed:&pointRed green:&pointGreen blue:&pointBlue alpha:&pointAlpha];
            pointRed *= pointAlpha * CPColorValueComponentMax;
            pointGreen *= pointAlpha * CPColorValueComponentMax;
            pointBlue *= pointAlpha * CPColorValueComponentMax;
            CGFloat screenAlpha = 1 - pointAlpha;
            
            static const CGBitmapInfo ARGB_32Little = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little;
            static const CGBitmapInfo RGBA_32Little = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little;
            static const CGBitmapInfo ARGB_32Big = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
            static const CGBitmapInfo RGBA_32Big = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
            unsigned char * pixels = CGBitmapContextGetData(context);
            if (pixels) {
                if ((bitmapInfo & ARGB_32Little) == ARGB_32Little) {
                    pixels[index + 2] = pointRed + pixels[index + 2] * screenAlpha;
                    pixels[index + 1] = pointGreen + pixels[index + 1] * screenAlpha;
                    pixels[index] = pointBlue + pixels[index] * screenAlpha;
                } else if ((bitmapInfo & RGBA_32Little) == RGBA_32Little) {
                    pixels[index + 3] = pointRed + pixels[index + 3] * screenAlpha;
                    pixels[index + 2] = pointGreen + pixels[index + 2] * screenAlpha;
                    pixels[index + 1] = pointBlue + pixels[index + 1] * screenAlpha;
                } else if ((bitmapInfo & ARGB_32Big) == ARGB_32Big) {
                    pixels[index + 1] = pointRed + pixels[index + 1] * screenAlpha;
                    pixels[index + 2] = pointGreen + pixels[index + 2] * screenAlpha;
                    pixels[index + 3] = pointBlue + pixels[index + 3] * screenAlpha;
                } else if ((bitmapInfo & RGBA_32Big) == RGBA_32Big) {
                    pixels[index] = pointRed + pixels[index] * screenAlpha;
                    pixels[index + 1] = pointGreen + pixels[index + 1] * screenAlpha;
                    pixels[index + 2] = pointBlue + pixels[index + 2] * screenAlpha;
                }
            }
        }
    } else if (drawContext.lineJoin == kCGLineJoinRound) {
        CGContextSaveGState(context);

        CGContextSetFillColorWithColor(drawContext.context, drawContext.lineColor.CGColor);
        CGContextBeginPath(context);
        CGFloat halfWidth = drawContext.lineWidth / 2;
        CGContextAddEllipseInRect(context, CGRectMake(self.position.x - halfWidth, self.position.y - halfWidth, drawContext.lineWidth, drawContext.lineWidth));
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
    } else {
        CGContextSaveGState(context);
        
        CGContextSetFillColorWithColor(drawContext.context, drawContext.lineColor.CGColor);
        CGContextBeginPath(context);
        CGFloat halfWidth = drawContext.lineWidth / 2;
        CGContextAddRect(context, CGRectMake(self.position.x - halfWidth, self.position.y - halfWidth, drawContext.lineWidth, drawContext.lineWidth));
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
    }
}

@end
