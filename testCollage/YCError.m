//
//  YCError.m
//  GithubClientt
//
//  Created by apple on 10.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCError.h"

@implementation YCError

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

+(void)showErrorNetworkDisabled {
    [self showAlertWithTitle:@"Сеть не доступна" message:@"Проверьте настройки интернет"];
}

+(void)showErrorServerDontRespond {
    [self showAlertWithTitle:@"Сайт не доступен" message:@"Ошибка на сервере. Попробуйте повторить позднее"];
}

@end
