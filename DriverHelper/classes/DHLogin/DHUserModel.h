//
//  DHUserModel.h
//  DriverHelper
//
//  Created by Gordon Su on 16/4/23.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHUserModel : NSObject

+ (DHUserModel *)sharedManager;

@property (nonatomic) NSInteger uid;

@end
