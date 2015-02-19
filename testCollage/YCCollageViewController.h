//
//  YCCollageViewController.h
//  testCollage
//
//  Created by apple on 03.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>

@class YCCollage;

@interface YCCollageViewController : UIViewController<MWPhotoBrowserDelegate>
@property (nonatomic, strong) YCCollage *collage;
@property (nonatomic, strong) NSArray *mediaPhotos;
@end
