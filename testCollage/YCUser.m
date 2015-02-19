//
//  YCUser.m
//  testCollage
//
//  Created by apple on 02.12.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCUser.h"

#define IS_NOT_EMPTY_STRING(str)  ((str) && [(str) isKindOfClass:NSString.class] && [(str) length] > 0)

@implementation YCUser
-(id)initWithServerResponse :(NSDictionary*) responseObject{
    self = [super init];
    if (self) {
        if(IS_NOT_EMPTY_STRING([responseObject objectForKey:@"username"])) {
            self.username = [responseObject objectForKey:@"username"];
        }
        NSString *urlAvatar = [responseObject objectForKey:@"profile_picture"];
        if (urlAvatar) {
            self.photoURL = [NSURL URLWithString:urlAvatar];
        }
        self.remoteID = [responseObject objectForKey:@"id"];
    }
    return self;
}
@end
