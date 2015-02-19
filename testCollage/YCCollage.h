//
//  YCCollage.h
//  testCollage
//
//  Created by apple on 03.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCCollage : NSObject
@property (nonatomic, readonly) NSArray *relativeFrames;
@property (nonatomic, copy) NSString *previewImageName;
@property (nonatomic) CGFloat ratio;
@end
