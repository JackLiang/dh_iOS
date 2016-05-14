//
//  AppDelegate.h
//  DriverHelper
//
//  Created by Gordon Su on 16/4/10.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHLocationTracker;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property DHLocationTracker *locationTracker;


@end

