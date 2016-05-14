//
//  DHReportModel.m
//  DriverHelper
//
//  Created by Gordon Su on 16/5/6.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHReportModel.h"

@implementation DHReportModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
               @"ID": @"id",
               @"descripte": @"description",
    };
}

@end
