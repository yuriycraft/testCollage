//
//  YCServerManager.m
//  testCollage
//
//  Created by apple on 02.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCServerManager.h"
#import "AFNetworking.h"
#import "YCUser.h"
#import "YCMedia.h"
#import "YCImage.h"

static NSString * const kBaseURLString = @"https://api.instagram.com/v1/";
static NSString * const kClientID = @"09eb51d4d3ab42518831408de280cbaf";
const CGFloat kYCMaxMediaCount = 100;

//347b12f52ddf4bdbb1e63319c213d897

@interface YCServerManager ()

@property (strong,nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

@end

@implementation YCServerManager
- (id)init
{
    self = [super init];
    if (self) {
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]init];//WithBaseURL:[NSURL URLWithString:kBaseURLString]];
    }
    return self;
}

+(YCServerManager*)sharedManager{
    
    static YCServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YCServerManager alloc]init];
    });
    return manager;
}

-(void)requestUsersWithUserName:(NSString *)username
                      onSuccess:(void(^)(YCUser* user)) success
                      onFailure:(void(^)(NSString* error)) failure{
    
    //
    [self.requestOperationManager GET:[NSString stringWithFormat:@"%@/users/search",kBaseURLString] parameters:@{@"client_id":kClientID,@"q" : username ?: @"", @"count" : @(NSIntegerMax)} success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        // NSLog(@"%@",responseObject);
        if(success){
            NSArray* userArray=responseObject[@"data"];
            //   NSMutableArray* objectsArray = [NSMutableArray array];
            if(userArray.count < 1) {
                NSLog(@"нет таких");
            }
            else for(NSDictionary* dict in userArray){
                YCUser* user = [[YCUser alloc]initWithServerResponse:dict] ;
                if ([user.username isEqual:username]) {
                    if(user){
                        success(user);
                    }
                }
                else {
                    success(nil);
                }
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"error_message: %@",operation.responseObject);
                                  
                                  if(failure) {
                                      failure(nil);
                                  }
                              }];
}

-(void)requestPhotoMediaWithLPhotos:(NSMutableArray *)photos
                              maxID:(NSString *)maxID
                      maxMediaCount:(unsigned)maxMediaCount
                           remoteID:(NSNumber*)userID
                          onSuccess:(void(^)(NSArray* photo)) success
                          onFailure:(void(^)(NSString* error)) failure{
    NSDictionary *params;
    if (maxID) {
        params = @{@"max_id" : maxID,@"client_id":kClientID};
    }else{
        params =@{@"client_id":kClientID};
    }
    [self.requestOperationManager GET:[NSString stringWithFormat:@"%@/users/%@/media/recent/",kBaseURLString, userID] parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        NSString *newMaxID = responseObject[@"pagination"][@"next_max_id"];
        
        NSArray* media = [responseObject objectForKey:@"data"];
        NSMutableArray* objectsArray = [NSMutableArray array];
        
        for(NSDictionary* dict in media){
            YCMedia* mediaObject = [[YCMedia alloc]initWithServerResponse:dict];
            [objectsArray addObject:mediaObject];
            
            //     NSLog(@"%@",mediaObject.lowResolutionImage.imageURL);
        }
        [photos addObjectsFromArray:[objectsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type =%d",                                                                  YCMediaTypePhoto]]];
        
        
        if ([photos count] > maxMediaCount || [newMaxID length] == 0) {
            if (success) {
                success([photos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"likesCount" ascending:NO]]]);
            }
        }
        else {
            [self requestPhotoMediaWithLPhotos:photos
                                         maxID:newMaxID
                                 maxMediaCount:maxMediaCount
                                      remoteID:userID
                                     onSuccess:success onFailure:nil];
        }
        
    }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSDictionary * dict=[NSDictionary dictionaryWithDictionary:operation.responseObject] ;
                                  NSDictionary* dictMeta = [dict objectForKey:@"meta"];
                                  NSString *message = [dictMeta objectForKey:@"error_message"];
                                  if (message) {
                                      NSLog(@"error_message: %@",message);
                                  }
                                  if(failure) {
                                      failure(nil);
                                  }
                              }];
}

-(void)requestSelectedPhotoWithUrl:(NSString*)url
                         onSuccess:(void(^)(UIImage *image)) success
                         onFailure:(void(^)(NSString* error)) failure{
    //  NSLog(@"%@",url);
    self.requestOperationManager.responseSerializer = [AFImageResponseSerializer serializer];
    [self.requestOperationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        UIImage* img = responseObject;
        if(success){
            success(img);
        }
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary * dict=[NSDictionary dictionaryWithDictionary:operation.responseObject] ;
        
        NSString *message= [dict objectForKey:@"message"];
        NSLog(@"ERROR: %@",operation);
        if(failure){
            failure(message);
        }
    }];
}

@end