//
//  DHLocationTracker.h
//  Location
//
//  Created by gordon
//  Copyright (c) 2016 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DHLocationShareModel.h"

typedef void (^DHLocationTrackerUpdateHandler)(NSString *text);

@interface DHLocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) DHLocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

@property (nonatomic, copy)DHLocationTrackerUpdateHandler updateHanler;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)startUpdateLocationToServer;
- (void)stopUpdateLocationToServer;
//- (void)updateLocationToServer;

- (void)setUpdateHanler:(DHLocationTrackerUpdateHandler)updateHanler;


@end
