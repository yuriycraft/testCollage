//
//  YCPreviewViewController.h
//  testCollage
//
//  Created by apple on 08.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface YCPreviewViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIImage *collageImage;
@end
