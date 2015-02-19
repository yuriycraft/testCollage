//
//  YCMedia.h
//  testCollage
//
//  Created by apple on 03.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCImage;
typedef NS_ENUM(NSUInteger, YCMediaType) {
    YCMediaTypePhoto = 0,
    YCMediaTypeVideo,
    YCMediaTypeUnknown
};

@interface YCMedia : NSObject

@property (nonatomic, copy) NSString *remoteID;
@property (nonatomic) NSInteger likesCount;
@property (nonatomic) YCMediaType type;
@property (nonatomic, strong) YCImage *lowResolutionImage;
@property (nonatomic, strong) YCImage *standartResolutionImage;
@property (nonatomic, strong) YCImage *thumbnailImage;

-(id)initWithServerResponse: (NSDictionary*) responseObject;
@end
