//
//  DHAddReportViewController.h
//  DriverHelper
//
//  Created by Gordon Su on 16/4/24.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import <UIKit/UIKit.h>

//1警察2拥堵3车祸4封路5施工）

typedef NS_ENUM (NSInteger, DHReportType) {
    DHReportTypePolice = 0,
    DHReportTypeJam = 1 << 0,
    DHReportTypeCrashes = 1 << 1,
    DHReportTypeClosure = 1 << 2,
    DHReportTypeConstruction = 1 << 3,
};

@interface DHAddReportViewController : SUIViewController

@property (nonatomic) DHReportType type;

@end
