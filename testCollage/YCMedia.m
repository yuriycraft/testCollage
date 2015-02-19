//
//  YCMedia.m
//  testCollage
//
//  Created by apple on 03.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCMedia.h"
#import "YCImage.h"

@implementation YCMedia

-(id)initWithServerResponse: (NSDictionary*) responseObject{
    self = [super init];
    if (self) {
        NSArray *mediaTypes = @[@"image", @"video"];
        self.type = [mediaTypes indexOfObject:responseObject[@"type"]];
        NSDictionary *imagesDict = responseObject[@"images"];
        self.thumbnailImage = [[YCImage alloc]initWithServerResponse:[imagesDict objectForKey:@"thumbnail"]];
        self.lowResolutionImage = [[YCImage alloc]initWithServerResponse:[imagesDict objectForKey:@"low_resolution"]];
        self.standartResolutionImage = [[YCImage alloc]initWithServerResponse:[imagesDict objectForKey:@"standard_resolution"]];
        self.remoteID = responseObject[@"id"];
        self.likesCount = [responseObject[@"likes"][@"count"] integerValue];
    }
    return self;
}
@end
