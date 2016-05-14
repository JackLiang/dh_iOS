//
//  SUIViewController.m
//  世界婴童网
//
//  Created by Gordon Su on 16/3/14.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SUIViewController.h"

#define CALLED_NONE       0
#define CALLED_ONCE       1
#define CALLED_TWICE_PLUS 2

@interface SUIViewController ()

@property (nonatomic) NSUInteger viewWillAppearCount;
@property (nonatomic) NSUInteger viewDidAppearCount;

@end

@implementation SUIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _viewWillAppearCount = MIN(_viewWillAppearCount + 1, CALLED_TWICE_PLUS);

    if (_viewWillAppearCount == CALLED_ONCE) {
        [self layoutSubviewsOfView];
        [self viewWillFirstAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    _viewDidAppearCount = MIN(_viewDidAppearCount + 1, CALLED_TWICE_PLUS);

    if (_viewDidAppearCount == CALLED_ONCE) {
        [self viewDidFirstAppear:animated];
    }
}

- (BOOL)isFirstViewWillAppear
{
    return _viewDidAppearCount == CALLED_ONCE;
}

- (BOOL)isFirstViewDidAppear
{
    return _viewDidAppearCount == CALLED_ONCE;
}

- (void)viewWillFirstAppear:(BOOL)animated
{
}

- (void)viewDidFirstAppear:(BOOL)animated
{
}

- (void)layoutSubviewsOfView
{
}

- (BOOL)sui_isVisible
{
    return self.isViewLoaded && self.view.window;
}

@end
