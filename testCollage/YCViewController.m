//
//  YCViewController.m
//  testCollage
//
//  Created by apple on 02.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCViewController.h"
#import "YCServerManager.h"
#import "YCUser.h"
#import "YCCollage.h"
#import "YCCollageViewController.h"
#import "YCInternetConnectionUtils.h"
#import "YCError.h"

@interface YCViewController ()

@end

@implementation YCViewController
@synthesize selectedUser,imagesArray,nameTextField;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imagesArray = [NSMutableArray array];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapRecognizer ];
}

-(void)initWithUser:(YCUser* ) user {
    selectedUser=user;
    if(![YCInternetConnectionUtils isConnectedToInternet]) {
        [YCError showErrorNetworkDisabled];
    }
    else if (![YCInternetConnectionUtils isWebSiteUp]) {
        [YCError showErrorServerDontRespond];
    }
    else
        [[YCServerManager sharedManager]requestPhotoMediaWithLPhotos:[NSMutableArray new] maxID:nil maxMediaCount:100 remoteID:selectedUser.remoteID onSuccess:^(NSArray *photo) {
            [self initWithMedia:photo];
        } onFailure:^(NSString *error) {
            [YCError showAlertWithTitle:@"Error" message:error];
        } ];
}

-(void)initWithMedia:(NSArray*) photo{
   
    imagesArray = [NSMutableArray arrayWithArray:photo];
    YCCollageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YCCollageViewController"];
    if (imagesArray) {
        vc.mediaPhotos = imagesArray;
        NSLog(@"%lu",(unsigned long)imagesArray.count);
        [self.navigationController pushViewController:vc animated:YES];}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Actions

- (IBAction)giveCollageAction:(id)sender {
    
    if(self.nameTextField.text.length<=0) {
        NSLog(@"введите имя");
    }
    else if(![YCInternetConnectionUtils isConnectedToInternet]) {
        [YCError showErrorNetworkDisabled];
    }
    else if (![YCInternetConnectionUtils isWebSiteUp]) {
        [YCError showErrorServerDontRespond];
    }
    else
        [[YCServerManager sharedManager]requestUsersWithUserName:self.nameTextField.text onSuccess:^(YCUser* user) {
            [self initWithUser:user];
        } onFailure:^(NSString *error) {
            if(error) {
                [YCError showAlertWithTitle:@"Error" message:error];
            }
        }];
}

- (void)tap:(UIGestureRecognizer *)gr{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self textFieldShouldReturn:textField];
}

@end
