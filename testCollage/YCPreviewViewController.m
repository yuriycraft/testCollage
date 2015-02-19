//
//  YCPreviewViewController.m
//  testCollage
//
//  Created by apple on 08.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCPreviewViewController.h"
#import "YCError.h"

@interface YCPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *previewView;

@end

@implementation YCPreviewViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(onSendButtonTap:)];
        self.navigationItem.title = @"Превью";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.previewView.image = self.collageImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)onSendButtonTap:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:@"Instagram photo collage"];
        NSData *imageData = UIImagePNGRepresentation(self.collageImage);
        [mailVC addAttachmentData:imageData mimeType:@"image/png" fileName:@"photoCollage"];
        [self presentViewController:mailVC animated:YES completion:nil];
    }
    else
        [YCError showAlertWithTitle:@"Error" message:@"Проверьте настройки email"];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultFailed) {
        [YCError showAlertWithTitle:@"Error" message:@"Не удалось отправить email"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
