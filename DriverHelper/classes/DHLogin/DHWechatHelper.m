//
//  DHWechatHelper.m
//  DriverHelper
//
//  Created by Gordon Su on 16/4/13.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHWechatHelper.h"

@interface DHWechatHelper ()

@end

@implementation DHWechatHelper

+ (DHWechatHelper *)sharedHelper
{
    static DHWechatHelper *staticManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticManager = [[DHWechatHelper alloc] init];
    });
    return staticManager;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)openWechat
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req
{
    
}

- (void)onResp:(BaseResp *)resp
{
    
}


@end
