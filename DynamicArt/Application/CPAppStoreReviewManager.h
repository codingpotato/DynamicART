//
//  CPAppStoreReviewManager.h
//  DynamicArtLite
//
//  Created by Wang Yongwu on 2019/10/19.
//  Copyright © 2019 codingpotato. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPAppStoreReviewManager : NSObject

+ (void)requestReviewIfAppropriate;

@end

NS_ASSUME_NONNULL_END
