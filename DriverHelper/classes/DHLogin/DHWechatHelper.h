//
//  DHWechatHelper.h
//  DriverHelper
//
//  Created by Gordon Su on 16/4/13.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#define ZKRWechatAppKey @"wx244828db3afc50cc"

@interface DHWechatHelper : NSObject<WXApiDelegate>

+ (DHWechatHelper *)sharedHelper;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)openWechat;

@end
