//
//  CPMailBodyCreator.m
//  DynamicArt
//
//  Created by wangyw on 4/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPMailBodyParser.h"

#import "CPBlockController.h"

@interface CPMailBodyParser ()

- (NSString *)encodeBase64WithData:(NSData *)data;

- (NSData *)decodeBase64WithString:(NSString *)string;

@end

@implementation CPMailBodyParser

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

static NSString *_urlScheme = @"codingpotato.dynamicart://";
static NSString *_operation = @"open?";

static NSString *_appContentKey = @"app_content";
static NSString *_thumbnailKey = @"thumbnail";
static NSString *_zhAppNameKey = @"zh_app_name";

- (id)initWithBlockController:(CPBlockController *)blockController thumbnailImage:(UIImage *)thumbnailImage {
    self = [super init];
    if (self) {
        NSAssert(blockController, @"");
        
        self.mailBody = [[NSMutableString alloc] init];
        [self.mailBody appendString:@"<html><body>"];
        NSString *imageString = nil;
        if (thumbnailImage) {
            imageString = [self encodeBase64WithData:UIImagePNGRepresentation(thumbnailImage)];
            [self.mailBody appendFormat:@"<img src=\"data:image/png;base64,%@\" />", imageString];
        }
        
        NSMutableString *exportString = [NSMutableString string];
        [blockController exportAllBlocksToString:exportString];
        NSString *htmlString = [exportString stringByReplacingOccurrencesOfString:@"|" withString:@"<br/>"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
        [self.mailBody appendFormat:@"<p>%@</p>", htmlString];

        self.urlString = [[NSMutableString alloc] init];
        [self.urlString appendFormat:@"%@open?%@=%@", _urlScheme, _appContentKey, [self encodeBase64WithData:[NSKeyedArchiver archivedDataWithRootObject:blockController]]];
        if (thumbnailImage) {
            [self.urlString appendFormat:@"&%@=%@", _thumbnailKey, imageString];
        }
        
        [self.mailBody appendFormat:@"<p><a href=\"%@", self.urlString];
        [self.mailBody appendString:@"\">Open in Dynamic ART</a></p></body></html>"];
        
    }
    return self;
}

- (id)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        NSString *urlString = url.absoluteString;
        NSString *zhAppName = nil;
        NSString *prefix = [_urlScheme stringByAppendingString:_operation];
        if ([urlString hasPrefix:prefix]) {
            urlString = [urlString stringByReplacingOccurrencesOfString:prefix withString:@""];
            NSArray *strings = [urlString componentsSeparatedByString:@"&"];
            for (NSString *string in strings) {
                NSRange range = [string rangeOfString:@"="];
                if (range.length == 1) {
                    NSString *key = [string substringToIndex:range.location];
                    NSString *value = [string substringFromIndex:range.location + 1];
                    if ([key isEqualToString:_appContentKey]) {
                        self.blockController = [NSKeyedUnarchiver unarchiveObjectWithData:[self decodeBase64WithString:value]];
                    } else if([key isEqualToString:_thumbnailKey]) {
                        self.thumbnailData = [self decodeBase64WithString:value];
                    } else if ([key isEqualToString:_zhAppNameKey]) {
                        zhAppName = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                }
            }
        }
        if (zhAppName && self.blockController && [[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"zh-"]) {
            self.blockController.appName = zhAppName;
        }
    }
    return self;
}

- (NSString *)encodeBase64WithData:(NSData *)data {
    int length = (int)data.length;
    if (length == 0) return nil;
    
    char *resultBytes = malloc(((length + 2) / 3) * 4 + 1);
    NSData *result = [NSData dataWithBytesNoCopy:resultBytes length:sizeof(resultBytes)];
    
    const unsigned char *dataBytes = data.bytes;
    while (length > 2) {
        *resultBytes++ = _base64EncodingTable[dataBytes[0] >> 2];
        *resultBytes++ = _base64EncodingTable[((dataBytes[0] & 0x03) << 4) + (dataBytes[1] >> 4)];
        *resultBytes++ = _base64EncodingTable[((dataBytes[1] & 0x0f) << 2) + (dataBytes[2] >> 6)];
        *resultBytes++ = _base64EncodingTable[dataBytes[2] & 0x3f];
        dataBytes += 3;
        length -= 3; 
    }
    if (length > 0) {
        *resultBytes++ = _base64EncodingTable[dataBytes[0] >> 2];
        if (length > 1) {
            *resultBytes++ = _base64EncodingTable[((dataBytes[0] & 0x03) << 4) + (dataBytes[1] >> 4)];
            *resultBytes++ = _base64EncodingTable[(dataBytes[1] & 0x0f) << 2];
            *resultBytes++ = '=';
        } else {
            *resultBytes++ = _base64EncodingTable[(dataBytes[0] & 0x03) << 4];
            *resultBytes++ = '=';
            *resultBytes++ = '=';
        }
    }
    *resultBytes = 0;
    return [NSString stringWithCString:result.bytes encoding:NSASCIIStringEncoding];
}

- (NSData *)decodeBase64WithString:(NSString *)string {
    int length = (int)string.length;
    if (length == 0) return nil;
    
    const char *stringBytes = [string cStringUsingEncoding:NSASCIIStringEncoding];
    int current, i = 0, j = 0;
    unsigned char * resultBytes = malloc(length);
    
    while ( ((current = *stringBytes++) != 0) && (length-- > 0) ) {
        if (current == '=') {
            if (*stringBytes != '=' && ((i % 4) == 1)) {
                free(resultBytes);
                return nil;
            }
            continue;
        }
        
        current = _base64DecodingTable[current];
        if (current == -1) {
            continue;
        } else if (current == -2) {
            free(resultBytes);
            return nil;
        }
        switch (i % 4) {
            case 0:
                resultBytes[j] = current << 2;
                break;
            case 1:
                resultBytes[j++] |= current >> 4;
                resultBytes[j] = (current & 0x0f) << 4;
                break;
            case 2:
                resultBytes[j++] |= current >>2;
                resultBytes[j] = (current & 0x03) << 6;
                break;
            case 3:
                resultBytes[j++] |= current;
                break;
        }
        i++;
    }
    int k = j;
    if (current == '=') {
        switch (i % 4) {
            case 1:
                free(resultBytes);
                return nil;
            case 2:
                k++;
                // flow through
            case 3:
                resultBytes[k] = 0;
        }
    }
    
    return [NSData dataWithBytesNoCopy:resultBytes length:j];
}

@end
