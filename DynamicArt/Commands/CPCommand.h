//
//  CPCommand.h
//  DynamicArt
//
//  Created by wangyw on 3/14/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@protocol CPDrawContext;

@interface CPCommand : NSObject

- (void)execute:(id<CPDrawContext>)drawContext;

@end
