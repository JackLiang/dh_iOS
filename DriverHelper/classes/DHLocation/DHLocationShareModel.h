//
//  DHLocationShareModel.h
//  Location
//
//  Created by gordon
//  Copyright (c) 2016 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHBackgroundTaskManager.h"
#import <CoreLocation/CoreLocation.h>

@interface DHLocationShareModel : NSObject

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer * delay10Seconds;
@property (nonatomic) DHBackgroundTaskManager * bgTask;
@property (nonatomic) NSMutableArray *myLocationArray;

@property (nonatomic) CLLocationCoordinate2D currentLocation;

@property (nonatomic, copy)CLPlacemark *placeMark;

+(id)sharedModel;

- (NSString *)getLocationString;

- (NSString *)getPostRepotAddressString;

- (void)saveCacheCity:(NSString *)city province:(NSString *)province;

- (NSString *)loadCacheCity;

- (NSString *)loadCacheProvince;

- (NSString *)loadCacheStreet;

@end
