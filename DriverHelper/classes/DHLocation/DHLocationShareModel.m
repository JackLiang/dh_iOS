//
//  DHLocationShareModel.m
//  Location
//
//  Created by gordon
//  Copyright (c) 2016 Location. All rights reserved.
//

#import "DHLocationShareModel.h"

#define USER_LOCATION_LATITUDE_KEY  @"user_location_latitude"
#define USER_LOCATION_LONGITUDE_KEY @"user_location_longitude"
#define USER_LOCATION_CITY_KEY      @"user_location_city"
#define USER_LOCATION_PROVINCE_KEY  @"user_location_province"

#define USER_DEFALUT_LOCATION_KEY   @"user_defalut_location_key"

#define LOCATION_GUIDE_DID_SHOW_KEY @"location_guide_did_show_key"

@interface DHLocationShareModel ()

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *street;

@end

@implementation DHLocationShareModel

//Class method to make sure the share model is synch across the app
+ (id)sharedModel
{
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)getLocationString
{
    NSString *str = [NSString stringWithFormat:@"%f-%f", self.currentLocation.latitude, self.currentLocation.longitude];
    return str;
}

- (NSString *)getPostRepotAddressString
{
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@", self.province,self.city,self.area];
    return str;
}

- (void)saveCacheCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSMutableDictionary *locationInfo = [[NSMutableDictionary alloc] init];

    locationInfo[USER_LOCATION_LATITUDE_KEY] = @(coordinate.latitude);
    locationInfo[USER_LOCATION_LONGITUDE_KEY] = @(coordinate.longitude);

    [[NSUserDefaults standardUserDefaults] setObject:locationInfo forKey:USER_DEFALUT_LOCATION_KEY];
}

- (void)saveCacheCity:(NSString *)city province:(NSString *)province
{
    NSMutableDictionary *locationInfo = [[NSMutableDictionary alloc] init];

    if (city) {
        locationInfo[USER_LOCATION_CITY_KEY] = city;
    }
    if (province) {
        locationInfo[USER_LOCATION_PROVINCE_KEY] = province;
    }

    [[NSUserDefaults standardUserDefaults] setObject:locationInfo forKey:USER_DEFALUT_LOCATION_KEY];
}

- (NSString *)loadCacheCity
{
    NSDictionary *locationInfo = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFALUT_LOCATION_KEY];

    return locationInfo[USER_LOCATION_CITY_KEY];
}

- (NSString *)loadCacheProvince
{
    NSDictionary *locationInfo = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFALUT_LOCATION_KEY];

    return locationInfo[USER_LOCATION_PROVINCE_KEY];
}

- (void)setPlaceMark:(CLPlacemark *)placeMark
{
    _placeMark = placeMark;

    NSString *city = nil;
    NSString *province = nil;

    NSString *citySuffix = @"市";
    NSString *provinceSuffix = @"省";

    NSRange range = [placeMark.locality rangeOfString:citySuffix];
    if (range.location != NSNotFound) {
        city = [placeMark.locality substringToIndex:range.location];
    } else {
        city = placeMark.locality;
    }

    range = [placeMark.administrativeArea rangeOfString:provinceSuffix];
    if (range.location != NSNotFound) {
        province = [placeMark.administrativeArea substringToIndex:range.location];
    } else {
        province = placeMark.administrativeArea;
    }
    NSDictionary *addressDictionary =  placeMark.addressDictionary;
    NSLog(@"=== %@", addressDictionary);
    self.province = addressDictionary[@"State"];
    self.city = addressDictionary[@"City"];
    self.area = addressDictionary[@"SubLocality"];
    self.street = addressDictionary[@"Thoroughfare"];
}

@end
