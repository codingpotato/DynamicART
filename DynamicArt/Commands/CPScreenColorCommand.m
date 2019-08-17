//
//  CPScreenColorCommand.m
//  DynamicArt
//
//  Created by wangyw on 11/24/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPScreenColorCommand.h"

#import "CPColorValue.h"
#import "CPDrawContext.h"

@implementation CPScreenColorCommand

- (void)execute:(id<CPDrawContext>)drawContext {
    CGContextRef context = drawContext.context;
    size_t bytesPerPixel = CGBitmapContextGetBitsPerPixel(context) / 8;
    CGBitmapInfo bitmapInfo = CGBitmapContextGetBitmapInfo(context);
    
    size_t width = CGBitmapContextGetWidth(context);
    size_t height = CGBitmapContextGetHeight(context);
    int scale = width / drawContext.size.width;
    self.position = CGPointMake(self.position.x * scale, self.position.y * scale);
    
    int index = 0;
    if (self.position.x < width && self.position.y < height) {
        index = (round(self.position.y) * width + round(self.position.x)) * bytesPerPixel;
    }
    unsigned char * pixels = CGBitmapContextGetData(context);
    unsigned char red = 0, green = 0, blue = 0;
    static const CGBitmapInfo ARGB_32Little = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little;
    static const CGBitmapInfo RGBA_32Little = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little;
    static const CGBitmapInfo ARGB_32Big = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
    static const CGBitmapInfo RGBA_32Big = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    if (pixels) {
        if ((bitmapInfo & ARGB_32Little) == ARGB_32Little) {
            red = pixels[index + 2];
            green = pixels[index + 1];
            blue = pixels[index];
        } else if ((bitmapInfo & RGBA_32Little) == RGBA_32Little) {
            red = pixels[index + 3];
            green = pixels[index + 2];
            blue = pixels[index + 1];
        } else if ((bitmapInfo & ARGB_32Big) == ARGB_32Big) {
            red = pixels[index + 1];
            green = pixels[index + 2];
            blue = pixels[index + 3];
        } else if ((bitmapInfo & RGBA_32Big) == RGBA_32Big) {
            red = pixels[index];
            green = pixels[index + 1];
            blue = pixels[index + 2];
        }
    }
    
    self.colorValue = [CPColorValue valueWithRed:red green:green blue:blue alpha:CPColorValueComponentMax];
}

@end
