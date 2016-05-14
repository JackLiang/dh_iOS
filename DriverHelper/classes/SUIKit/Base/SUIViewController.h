//
//  SUIViewController.h
//  世界婴童网
//
//  Created by Gordon Su on 16/3/14.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUIViewController : UIViewController

- (BOOL)isFirstViewWillAppear;
- (BOOL)isFirstViewDidAppear;

- (void)viewWillFirstAppear:(BOOL)animated;
- (void)viewDidFirstAppear:(BOOL)animated;

- (void)layoutSubviewsOfView;

- (BOOL)sui_isVisible;

@end
