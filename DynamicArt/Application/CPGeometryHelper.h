//
//  CPGeometryHelper.h
//  DynamicArt
//
//  Created by wangyw on 3/11/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#ifndef Dynamic_CPGeometryHelper_h
#define Dynamic_CPGeometryHelper_h

static inline CGRect CPRectMoveOriginTo(CGRect rect, CGPoint origin) {
    rect.origin = origin;
    return rect;
}

static inline CGRect CPRectMoveOriginXTo(CGRect rect, CGFloat x) {
    rect.origin.x = x;
    return rect;
}

static inline CGRect CPRectMoveOriginYTo(CGRect rect, CGFloat y) {
    rect.origin.y = y;
    return rect;
}

static inline CGRect CPRectSetSize(CGRect rect, CGSize size) {
    rect.size = size;
    return rect;
}

static inline CGRect CPRectEnlarge(CGRect rect, CGFloat enlargeSize) {
    rect.origin.x -= enlargeSize;
    rect.origin.y -= enlargeSize;
    rect.size.width += enlargeSize * 2;
    rect.size.height += enlargeSize * 2;
    return rect;
}

static inline CGRect CPRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = width;
    return rect;
}

static inline CGRect CPRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = height;
    return rect;
}

static inline CGRect CPRectIncreaseSize(CGRect rect, CGSize deltaSize) {
    rect.size.width += deltaSize.width;
    rect.size.height += deltaSize.height;
    return rect;
}

static inline CGRect CPRectIncreaseWidth(CGRect rect, CGFloat deltaWidth) {
    rect.size.width += deltaWidth;
    return rect;
}

static inline CGRect CPRectIncreaseHeight(CGRect rect, CGFloat deltaHeight) {
    rect.size.height += deltaHeight;
    return rect;
}

static inline CGRect CPRectTranslate(CGRect rect, CGPoint translation) {
    rect.origin.x += translation.x;
    rect.origin.y += translation.y;
    return rect;
}

static inline CGPoint CPRectCenter(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

static inline CGPoint CPPointTranslate(CGPoint point, CGPoint translation) {
    point.x += translation.x;
    point.y += translation.y;
    return point;
}

static inline CGPoint CPPointTranslateByX(CGPoint point, CGFloat x) {
    point.x += x;
    return point;
}

static inline CGPoint CPPointTranslateByY(CGPoint point, CGFloat y) {
    point.y += y;
    return point;
}

static inline BOOL CPRectEqualToRect(CGRect rect1, CGRect rect2) {
    CGFloat tolerance = 1e-8;
    if ((rect1.origin.x - rect2.origin.x < tolerance) && (rect1.origin.y - rect2.origin.y < tolerance)
        && (rect1.size.width - rect2.size.width < tolerance) && (rect1.size.height - rect2.size.height < tolerance)) {
        return YES;
    } else {
        return NO;
    }
}

#endif
