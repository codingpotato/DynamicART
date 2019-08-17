//
//  CPDrawContext.h
//  DynamicArt
//
//  Created by wangyw on 3/20/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPDrawContext

- (CGContextRef)context;

- (void)setContext:(CGContextRef)context;

- (CGSize)size;

- (void)setSize:(CGSize)size;

- (CGPoint)position;

- (void)setPosition:(CGPoint)position;

- (CGFloat)angle;

- (void)setAngle:(CGFloat)angle;

- (BOOL)penDown;

- (void)setPenDown:(BOOL)penDown;

- (BOOL)turtleShown;

- (BOOL)setTurtleShown:(BOOL)turtleShown;

- (UIColor *)lineColor;

- (void)setLineColor:(UIColor *)lineColor;

- (UIColor *)fillColor;

- (void)setFillColor:(UIColor *)fillColor;

- (double)lineWidth;

- (void)setLineWidth:(double)lineWidth;

- (CGLineJoin)lineJoin;

- (void)setLineJoin:(CGLineJoin)lineJoin;

- (NSString *)fontName;

- (void)setFontName:(NSString *)fontName;

- (CGFloat)fontSize;

- (void)setFontSize:(CGFloat)fontSize;

- (BOOL)autoRefresh;

- (void)setAutoRefresh:(BOOL)autoRefresh;

- (void)refresh;

- (void)addLog:(NSString *)log;

- (void)waitForInterval:(NSTimeInterval)interval condition:(NSCondition *)condition;

- (void)playSound:(float)frequency timeInterval:(NSTimeInterval)interval condition:(NSCondition *)condition;

- (void)setBeatsPerMinute:(float)beatsPerMinute;

- (void)playMusic:(NSString *)musicString condition:(NSCondition *)condition;

@end
