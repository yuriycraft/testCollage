//
//  YCCollageViewController.m
//  testCollage
//
//  Created by apple on 03.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCCollageViewController.h"
#import "YCCollage.h"
#import "YCCollageElementView.h"
#import "YCUser.h"
#import "YCMedia.h"
#import "YCServerManager.h"
#import "UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "UIView+ImageRender.h"
#import "YCPreviewViewController.h"
#import "YCInternetConnectionUtils.h"
#import "YCError.h"

#import <QuartzCore/CALayer.h>

#import <MWPhotoBrowser/MWPhotoBrowser.h>

#import "YCImage.h"
@interface YCPhotoBrowser : MWPhotoBrowser

@end

@implementation YCPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:@"Выберите картинку"];
}

@end


@interface YCCollageViewController ()
@property (nonatomic, strong) UIView *collageView;
@property (weak, nonatomic) YCCollageElementView *currentCollageElementView;

@end

@implementation YCCollageViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collageView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., self.view.frame.size.width, self.view.frame.size.width)];
    self.collageView.backgroundColor = [UIColor whiteColor];
    self.collageView.layer.cornerRadius = 5.;
    
    self.collageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collageView];
    self.collageView.backgroundColor = [UIColor whiteColor];
    self.collageView.layer.cornerRadius = 5.;
    YCCollageElementView* elementView1 = [[YCCollageElementView alloc]init];
    elementView1.frame = CGRectMake(7, 7, 150, 150);
    
    [self.collageView addSubview:elementView1];
    YCCollageElementView* elementView2 = [[YCCollageElementView alloc]init];
    elementView2.frame = CGRectMake(7, 162, 150, 150);
    
    [self.collageView addSubview:elementView2];
    YCCollageElementView* elementView3 = [[YCCollageElementView alloc]init];
    elementView3.frame = CGRectMake(162, 7, 150, 150);
    
    [self.collageView addSubview:elementView3];
    YCCollageElementView* elementView4 = [[YCCollageElementView alloc]init];
    elementView4.frame = CGRectMake(162, 162, 150, 150);
    [self.collageView addSubview:elementView4];
    [elementView1 addTarget:self action:@selector(onCollageElementTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [elementView2 addTarget:self action:@selector(onCollageElementTap:) forControlEvents:UIControlEventTouchUpInside];
    [elementView3 addTarget:self action:@selector(onCollageElementTap:) forControlEvents:UIControlEventTouchUpInside];
    [elementView4 addTarget:self action:@selector(onCollageElementTap:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)onCollageElementTap:(id)sender {
    self.currentCollageElementView = sender;
    
    MWPhotoBrowser *browser = [[YCPhotoBrowser alloc] initWithDelegate:self];
    browser.enableGrid = YES;
    browser.displayActionButton = NO;
    browser.displaySelectionButtons = YES;
    browser.startOnGrid = YES;
    [browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:browser animated:YES];
    //    NSLog(@"%lu",(unsigned long)self.mediaPhotos.count);
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.mediaPhotos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto* ph = [MWPhoto  photoWithURL:[[[self.mediaPhotos objectAtIndex:index]standartResolutionImage]imageURL]];
    return ph;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index{
    if (index < self.mediaPhotos.count) {
        MWPhoto* ph = [MWPhoto photoWithURL:[[[self.mediaPhotos objectAtIndex:index]thumbnailImage]imageURL]];
        return ph;
    }
    return nil;
}
- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return NO;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [self.navigationController popViewControllerAnimated:YES];
    NSString* urlString = [[[[self.mediaPhotos objectAtIndex:index]standartResolutionImage]imageURL]absoluteString];
    [self onPhotoSelected:urlString];
}

- (void)onPhotoSelected:(NSString *)photoImageUrl {
    if (photoImageUrl) {
        if(![YCInternetConnectionUtils isConnectedToInternet]) {
            [YCError showErrorNetworkDisabled];
        }
        else if (![YCInternetConnectionUtils isWebSiteUp]) {
            [YCError showErrorServerDontRespond];
        }
        else
            [[YCServerManager sharedManager]requestSelectedPhotoWithUrl:photoImageUrl onSuccess:^(UIImage *image) {
                [self setImage:image];
                
            } onFailure:^(NSString *error) {
                [YCError showAlertWithTitle:@"Error" message:error];
            }
             
             ];
    }
}

-(void)setImage:(UIImage*)image{
    if (image) {
        self.currentCollageElementView.image=image;
        NSArray *images = [[self.collageView.subviews valueForKey:@"image"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject isKindOfClass:[UIImage class]];
        }]];
        NSLog(@"%lu",(unsigned long)images.count);
    }
}

- (IBAction)onDoneButtonTap:(id)sender {
    YCPreviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YCPreviewController"];
    vc.collageImage = [self.collageView renderImage];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)dealloc{
    
}

@end