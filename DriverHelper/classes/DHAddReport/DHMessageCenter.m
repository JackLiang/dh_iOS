//
//  DHMessageCenter.m
//  DriverHelper
//
//  Created by Gordon Su on 16/5/6.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHMessageCenter.h"
#import "DHLocationShareModel.h"
#import "DHUserModel.h"

@interface DHMessageCenter ()
{
    BOOL _isInitialized;
}

@property (nonatomic, weak) NSTimer *reportMessageTimer;

@end

@implementation DHMessageCenter

+ (DHMessageCenter *)curCenter
{
    static DHMessageCenter *staticManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticManager = [[DHMessageCenter alloc] init];
    });
    return staticManager;
}

- (void)initServer
{
    if (!_isInitialized) {
        _isInitialized = YES;
        //开启服务
        [self performSelector:@selector(startServer) withObject:nil afterDelay:0.1];
    }
}

- (void)startServer
{
    if (_isInitialized) {
        _isInitialized = YES;
        [self runTimer];
    }
}

- (void)pauseServer
{
    if (!_isInitialized) {
        return;
    }
}

- (void)resumeServer
{
    if (!_isInitialized) {
        return;
    }
    [self runTimer];
}

- (void)runTimer
{
    NSTimeInterval delay =  10;
    [self performSelector:@selector(reportMessageTimeRun) withObject:nil afterDelay:delay];
}

- (void)reportMessageTimeRun
{
    [self.reportMessageTimer fire];
}

- (NSTimer *)reportMessageTimer
{
    if (!_reportMessageTimer) {
        _reportMessageTimer = [NSTimer scheduledTimerWithTimeInterval:1 * 60 target:self selector:@selector(getReportFormServer) userInfo:nil repeats:YES];
    }
    return _reportMessageTimer;
}

- (void)getReportFormServer
{
    SWSHTTPRequest *request = [[SWSHTTPRequest alloc] initWithBaseUrl:GetReportUrl];
    request.POST = YES;
    [request setQueryValue:@"1" forKey:@"interest"];
    [request setQueryValue:[[DHLocationShareModel sharedModel] getLocationString] forKey:@"location"];
    [request setQueryValue:@"广州市-海珠区-赤岗" forKey:@"address"];
    [request setQueryValue:@([DHUserModel sharedManager].uid) forKey:@"user_id"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWSHTTPResponse *response = [[SWSAPIHelper defaultHelper] callRequest:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.isSuccess) {
            }
            [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"获取消息 ：%d", response.isSuccess] dismissAfter:1.];
        });
    });
}

@end
