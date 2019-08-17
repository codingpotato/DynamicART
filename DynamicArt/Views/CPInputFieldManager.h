//
//  CPInputFieldManager.h
//  DynamicArt
//
//  Created by wangyw on 10/13/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPCacheManager.h"

@class CPArgumentView;
@class CPInputField;
@class CPInputFieldManager;

@protocol CPInputFieldManagerDelegate <NSObject>

- (void)inputFieldManager:(CPInputFieldManager *)inputFieldManager didShowInputField:(CPInputField *)inputField;

- (void)inputFieldManager:(CPInputFieldManager *)inputFieldManager willHideInputField:(CPInputField *)inputField;

@end

@interface CPInputFieldManager : NSObject <CPCacheItem>

@property (weak, nonatomic) id<CPInputFieldManagerDelegate> delegate;

@property (strong, nonatomic) CPInputField *currentInputField;

+ (CPInputFieldManager *)defaultInputFieldManager;

- (Class)inputFieldClassOfValueClass:(Class)valueClass;

- (void)showInputFieldOfClass:(Class)inputFieldClass forArgumentView:(CPArgumentView *)argumentView;

- (void)hideCurrentInputField;

- (void)adjustFrame;

- (void)autoCompleteViewDismissed;

@end
