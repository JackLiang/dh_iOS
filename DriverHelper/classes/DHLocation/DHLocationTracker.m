//
//  DHLocationTracker.m
//  Location
//
//  Created by gordon
//  Copyright (c) 2016 Location All rights reserved.
//

#import "DHLocationTracker.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <iflyMSC/iflyMSC.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import "DHUserModel.h"
#import "DHReportModel.h"

#define LATITUDE         @"latitude"
#define LONGITUDE        @"longitude"
#define ACCURACY         @"theAccuracy"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface DHLocationTracker ()<IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) IFlySpeechSynthesizer *ifly;

@property (nonatomic) CLGeocoder *geocoder;

@property (nonatomic) NSTimer *locationUpdateTimer;

@end

@implementation DHLocationTracker

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (CLLocationManager *)sharedLocationManager
{
    static CLLocationManager *_locationManager;

    @synchronized(self) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            _locationManager.allowsBackgroundLocationUpdates = YES;
            _locationManager.pausesLocationUpdatesAutomatically = NO;
        }
    }
    return _locationManager;
}

- (id)init
{
    if (self == [super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [DHLocationShareModel sharedModel];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)applicationEnterBackground
{
    CLLocationManager *locationManager = [DHLocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;

    if (IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];

    //Use the DHBackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [DHBackgroundTaskManager sharedDHBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void)restartLocationUpdates
{
//    NSLog(@"restartLocationUpdates");

    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }

    CLLocationManager *locationManager = [DHLocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;

    if (IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)startLocationTracking
{
//    NSLog(@"startLocationTracking");

    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    } else {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];

        if (authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted) {
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [DHLocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager.distanceFilter = kCLDistanceFilterNone;

            if (IS_OS_8_OR_LATER) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
}

- (void)stopLocationTracking
{
//    NSLog(@"stopLocationTracking");

    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }

    CLLocationManager *locationManager = [DHLocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    NSLog(@"locationManager didUpdateLocations");

    for (int i = 0; i < locations.count; i++) {
        CLLocation *newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;

        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];

//        if (locationAge > 30.0) {
//            continue;
//        }

        //Select only valid location and also location with good accuracy
        if (newLocation != nil && theAccuracy > 0
            && theAccuracy < 2000
            && (!(theLocation.latitude == 0.0 && theLocation.longitude == 0.0))) {
            self.myLastLocation = theLocation;
            self.myLastLocationAccuracy = theAccuracy;

            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];

            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            [self.shareModel.myLocationArray addObject:dict];

            [[DHLocationShareModel sharedModel] setCurrentLocation:theLocation];
        }

        [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                [self saveCacheLocationInfo:[placemarks firstObject]];
            }
        }];
    }

    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }

    self.shareModel.bgTask = [DHBackgroundTaskManager sharedDHBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];

    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];

    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }

    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                                    selector:@selector(stopLocationDelayBy10Seconds)
                                                                    userInfo:nil
                                                                     repeats:NO];
}

- (void)saveCacheLocationInfo:(CLPlacemark *)placemark
{
    if (!placemark) {
        return;
    }

    NSString *city = nil;
    NSString *province = nil;
    NSString *citySuffix = @"市";
    NSString *provinceSuffix = @"省";

    NSRange range = [placemark.locality rangeOfString:citySuffix];
    if (range.location != NSNotFound) {
        city = [placemark.locality substringToIndex:range.location];
    } else {
        city = placemark.locality;
    }

    range = [placemark.administrativeArea rangeOfString:provinceSuffix];
    if (range.location != NSNotFound) {
        province = [placemark.administrativeArea substringToIndex:range.location];
    } else {
        province = placemark.administrativeArea;
    }
    [[DHLocationShareModel sharedModel] saveCacheCity:city province:province];
    
    [[DHLocationShareModel sharedModel]  setPlaceMark:placemark];
}

//Stop the locationManager
- (void)stopLocationDelayBy10Seconds
{
    CLLocationManager *locationManager = [DHLocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];

    NSLog(@"locationManager stop Updating after 10 seconds");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // NSLog(@"locationManager error:%@",error);

    switch ([error code]) {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        break;
        case kCLErrorDenied: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        break;
        default: {
        }
        break;
    }
}

- (void)startUpdateLocationToServer
{
    [self.locationUpdateTimer fire];
}

- (void)stopUpdateLocationToServer
{
    [_locationUpdateTimer invalidate];
    _locationUpdateTimer = nil;
}

//Send the location to Server
- (void)updateLocationToServer
{
    NSLog(@"updateLocationToServer");

    // Find the best location from the array based on accuracy
    NSMutableDictionary *myBestLocation = [[NSMutableDictionary alloc]init];

    for (int i = 0; i < self.shareModel.myLocationArray.count; i++) {
        NSMutableDictionary *currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];

        if (i == 0) myBestLocation = currentLocation;
        else {
            if ([[currentLocation objectForKey:ACCURACY]floatValue] <= [[myBestLocation objectForKey:ACCURACY]floatValue]) {
                myBestLocation = currentLocation;
            }
        }
    }
    NSLog(@"My Best location:%@", myBestLocation);

    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if (self.shareModel.myLocationArray.count == 0) {
        NSLog(@"Unable to get location, use the last known location");

        self.myLocation = self.myLastLocation;
        self.myLocationAccuracy = self.myLastLocationAccuracy;
    } else {
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude = [[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude = [[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation = theBestLocation;
        self.myLocationAccuracy = [[myBestLocation objectForKey:ACCURACY]floatValue];
    }

    NSString *text = [NSString stringWithFormat:@"上传到服务器,维度为：(%f) 经度为(%f) 精确度(%f)", self.myLocation.latitude, self.myLocation.longitude, self.myLocationAccuracy];
    NSLog(@"=== Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)", self.myLocation.latitude, self.myLocation.longitude, self.myLocationAccuracy);
    [self updateLabel:text];

    //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server

    [self getReportFormServer];
}

- (void)getReportFormServer
{
    SWSHTTPRequest *request = [[SWSHTTPRequest alloc] initWithBaseUrl:GetReportUrl];
    request.POST = YES;
    [request setQueryValue:@"2" forKey:@"interest"];
    [request setQueryValue:[[DHLocationShareModel sharedModel] getLocationString] forKey:@"location"];
    [request setQueryValue:[[DHLocationShareModel sharedModel] getPostRepotAddressString] forKey:@"address"];
    [request setQueryValue:@([DHUserModel sharedManager].uid) forKey:@"user_id"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWSHTTPResponse *response = [[SWSAPIHelper defaultHelper] callRequest:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *array = [NSArray yy_modelArrayWithClass:[DHReportModel class] json:response.dataDictionary];
            if (array.count) {
                DHReportModel *report = array[0];
                NSString *text = [NSString stringWithFormat:@"新消息 %d %@", response.isSuccess, report.descripte];
                [self playWithIfly:text];
            }
            
            [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"获取消息 ：%d", response.isSuccess] dismissAfter:1.];

            
        });
    });
}

- (DHReportModel *)reportModel
{
    DHReportModel *report = [[DHReportModel alloc] init];
    report.title = @"tilte";
    report.type = @"type";
//    report.desc = @"desc";
    report.imgs = @"imgs";
    report.location = @"location";
    report.address = @"广州市-海珠区-赤岗";
//    report.create_time = @"create_time";

    return report;
}

- (void)clean
{
    //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
    [self.shareModel.myLocationArray removeAllObjects];
    self.shareModel.myLocationArray = nil;
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
}

- (void)updateLabel:(NSString *)text
{
    if (self.updateHanler) {
        self.updateHanler(text);
    }
}

- (void)play:(NSString *)text
{
    SystemSoundID soundID = 0;
    NSString *soundFilepath = [[NSBundle mainBundle] pathForResource:@"sou" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL URLWithString:soundFilepath], &soundID);

    AudioServicesPlaySystemSound(soundID);
}

- (void)playWithIfly:(NSString *)text
{
    if (!self.ifly) {
        self.ifly = [[IFlySpeechSynthesizer alloc] init];
        [self.ifly setDelegate:self];
    }

    [self.ifly startSpeaking:text];
}

#pragma mark - IFlySpeechSynthesizerDelegate
- (void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"IFlySpeechError : %@", [error errorDesc]);
    [JDStatusBarNotification showWithStatus:[error errorDesc] dismissAfter:1.0];
}

- (void)onSpeakBegin
{
}

- (void)onSpeakCancel
{
}

- (void)onSpeakPaused
{
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

#pragma mark - proerty 

- (NSTimer *)locationUpdateTimer
{
    if (!_locationUpdateTimer) {
        _locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateLocationToServer) userInfo:nil repeats:YES];
    }
    return _locationUpdateTimer;
}


@end
