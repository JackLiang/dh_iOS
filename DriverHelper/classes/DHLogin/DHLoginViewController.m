//
//  DHLoginViewController.m
//  DriverHelper
//
//  Created by Gordon Su on 16/4/13.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHLoginViewController.h"
#import "DHWechatHelper.h"

@interface DHLoginViewController()

@property (nonatomic ,strong)UIButton *weChatLoginButton;

@end

@implementation DHLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.weChatLoginButton];
}

- (void)layoutSubviewsOfView
{
    self.weChatLoginButton.frame = CGRectMake(0, 0, 100, 44);
}

#pragma mark - target

- (void)webChatLogin
{
    [[DHWechatHelper sharedHelper] openWechat];
    
//    SendAuthReq *req = [[SendAuthReq alloc] init];
//    req.scope = @"snsapi_userinfo";
//    [WXApi sendAuthReq:req viewController:self delegate:[DHWechatHelper sharedHelper]];
}

#pragma mark - property method

- (UIButton *)weChatLoginButton
{
    if (!_weChatLoginButton) {
        _weChatLoginButton = [[UIButton alloc] init];
        [_weChatLoginButton setTitle:@"微信登陆" forState:UIControlStateNormal];
        [_weChatLoginButton addTarget:self action:@selector(webChatLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weChatLoginButton;
}

@end
