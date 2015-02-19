//
//  YCViewController.h
//  testCollage
//
//  Created by apple on 02.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCUser,YCCollage;
@interface YCViewController : UIViewController < UITextFieldDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) YCUser *selectedUser;
@property (nonatomic, strong) YCCollage *selectedCollage;

@property (nonatomic, strong) NSArray *collages;
@property (nonatomic, strong) NSMutableDictionary *previewImages;
@property (strong, nonatomic) NSMutableArray *imagesArray;
- (IBAction)giveCollageAction:(id)sender;



@end
