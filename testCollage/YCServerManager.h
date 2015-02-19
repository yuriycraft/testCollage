//
//  YCServerManager.h
//  testCollage
//
//  Created by apple on 02.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCUser;


@interface YCServerManager : NSObject
+(YCServerManager*)sharedManager;
-(void)requestUsersWithUserName:(NSString *)username
                      onSuccess:(void(^)(YCUser* user)) success
                      onFailure:(void(^)(NSString* error)) failure;
-(void)requestPhotoMediaWithLPhotos:(NSMutableArray *)photos
                              maxID:(NSString *)maxID
                      maxMediaCount:(unsigned)maxMediaCount
                           remoteID:(NSNumber*)userID
                          onSuccess:(void(^)(NSArray* photo)) success
                          onFailure:(void(^)(NSString* error)) failure;
-(void)requestSelectedPhotoWithUrl:(NSString *) url
                         onSuccess:(void(^)(UIImage *image)) success
                         onFailure:(void(^)(NSString* error)) failure;
@end
