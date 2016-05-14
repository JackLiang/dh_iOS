//
//  DHUserModel.m
//  DriverHelper
//
//  Created by Gordon Su on 16/4/23.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHUserModel.h"

@implementation DHUserModel

+ (DHUserModel *)sharedManager
{
    static DHUserModel *staticManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticManager = [[DHUserModel alloc] init];
    });
    return staticManager;
}

@end
