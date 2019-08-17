//
//  CPMailBodyCreator.h
//  DynamicArt
//
//  Created by wangyw on 4/25/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

@class CPBlockController;

@interface CPMailBodyParser : NSObject

@property (strong, nonatomic) NSMutableString *mailBody;

@property (strong, nonatomic) NSMutableString *urlString;

@property (strong, nonatomic) CPBlockController *blockController;

@property (strong, nonatomic) NSData *thumbnailData;

- (id)initWithBlockController:(CPBlockController *)blockController thumbnailImage:(UIImage *)thumbnailImage;

- (id)initWithUrl:(NSURL *)url;

@end
