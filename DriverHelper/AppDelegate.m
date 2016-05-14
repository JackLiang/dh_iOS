//
//  AppDelegate.m
//  DriverHelper
//
//  Created by Gordon Su on 16/4/10.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "AppDelegate.h"
#import "DHLocationTracker.h"
#import "ViewController.h"
#import <iflyMSC/iflyMSC.h>
#import "DHWechatHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIAlertView *alert = nil;

    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
    } else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
    } else {
        self.locationTracker = [[DHLocationTracker alloc]init];
        __weak AppDelegate *weakSelf = self;
        [self.locationTracker setUpdateHanler:^(NSString *text) {
            [[(ViewController *)weakSelf.window.rootViewController locationUpdatelabel] setText:text];
        }];

        [self.locationTracker startLocationTracking];
        //Send the best location to server every 60 seconds
    }

    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"570b636c"];
    [IFlySpeechUtility createUtility:initString];

    [self initThirdLogin];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    [self.locationTracker startLocationTracking];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    [self.locationTracker stopLocationTracking];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options
{
    NSString *urlScheme = [url scheme];
    if ([urlScheme isEqualToString:ZKRWechatAppKey]) {
        return [[DHWechatHelper sharedHelper] handleOpenURL:url];
    }
    return YES;
}

#pragma mark - Internal Methods
- (void)initThirdLogin
{
    [WXApi registerApp:ZKRWechatAppKey];
}

@end
