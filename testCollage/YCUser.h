//
//  YCUser.h
//  testCollage
//
//  Created by apple on 02.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCUser : NSObject
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic) NSNumber* remoteID;

-(id)initWithServerResponse :(NSDictionary*) responseObject;
@end
