//
//  YCImage.h
//  testCollage
//
//  Created by apple on 03.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhoto.h"

@interface YCImage : MWPhoto

@property (nonatomic, strong) UIImage *underlyingImage;
@property (nonatomic) CGSize size;
@property (nonatomic, strong) NSURL *imageURL;

-(id)initWithServerResponse: (NSDictionary*) responseObject;
@end
