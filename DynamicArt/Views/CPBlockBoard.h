//
//  CPBlockBoard.h
//  DynamicArt
//
//  Created by wangyw on 4/28/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPTapDetectDelegate;

@interface CPBlockBoard : UIScrollView

@property (weak, nonatomic) IBOutlet id<CPTapDetectDelegate> tapDetectDelegate;

@end
