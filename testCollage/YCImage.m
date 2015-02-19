//
//  YCImage.m
//  testCollage
//
//  Created by apple on 03.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCImage.h"

@implementation YCImage

-(id)initWithServerResponse: (NSDictionary*) responseObject{
    self = [super init];
    if (self) {
        self.imageURL = [NSURL URLWithString:responseObject[@"url"]];
        self.size = CGSizeMake([responseObject[@"width"] floatValue], [responseObject[@"height"] floatValue]);
    }
    return self;
}

@end
