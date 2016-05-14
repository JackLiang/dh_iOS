//
//  DHMapPin.m
//  DriverHelper
//
//  Created by Gordon Su on 16/5/1.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHMapPin.h"

@interface DHMapPin ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

@implementation DHMapPin

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description
{
    self = [super init];
    if (self != nil) {
        _coordinate = location;
        _title = placeName;
        _subtitle = description;
    }
    return self;
}

@end
