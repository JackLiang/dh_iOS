//
//  CYLTabBarController.h
//  CYLCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

@import Foundation;
@import UIKit;

static NSString * const CYLTabBarItemTitle = @"tabBarItemTitle";
static NSString * const CYLTabBarItemImage = @"tabBarItemImage";
static NSString * const CYLTabBarItemSelectedImage = @"tabBarItemSelectedImage";

FOUNDATION_EXTERN NSUInteger CYLTabbarItemsCount;
FOUNDATION_EXTERN CGFloat CYLPlusButtonWidth;
FOUNDATION_EXTERN CGFloat CYLTabBarItemWidth;
FOUNDATION_EXTERN NSString *const CYLTabBarItemWidthDidUpdate;

@import UIKit;

@interface CYLTabBarController : UITabBarController

/**
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, readwrite, copy) NSArray<UIViewController *> *viewControllers;
/**
 * The Attributes of items which is displayed on the tab bar.
 */
@property (nonatomic, readwrite, copy) NSArray<NSDictionary *> *tabBarItemsAttributes;

/*!
 * Judge if there is plus button.
 */
+ (BOOL)havePlusButton;

/*!
 * Include plusButton if exists.
 */
+ (NSUInteger)allItemsInTabBarCount;

- (id<UIApplicationDelegate>)appDelegate;
- (UIWindow *)rootWindow;

@end

@interface NSObject (CYLTabBarController)

/**
 * If `self` is kind of `UIViewController`, this method will return the nearest ancestor in the view controller hierarchy that is a tab bar controller. If `self` is not kind of `UIViewController`, it will return the `rootViewController` of the `rootWindow` as long as you have set the `CYLTabBarController` as the  `rootViewController`. Otherwise return nil. (read-only)
 */
@property (nonatomic, readonly) CYLTabBarController *cyl_tabBarController;

@end
