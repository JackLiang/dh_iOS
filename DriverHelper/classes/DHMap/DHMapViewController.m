//
//  DHMapViewController.m
//  DriverHelper
//
//  Created by Gordon Su on 16/4/12.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHMapViewController.h"
//#import <MapKit/MapKit.h>

//@interface DHMapViewController()<MKMapViewDelegate>
//
//@property (nonatomic, strong) MKMapView *mapView;
//
//@end

@implementation DHMapViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//#pragma mark - MKMapViewDelegate
//
//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
//{
//    
//}
//
//#pragma mark - property
//
//- (MKMapView *)mapView
//{
//    if (!_mapView) {
//        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
//        _mapView.delegate = self;
//    }
//    return _mapView;
//}


@end
