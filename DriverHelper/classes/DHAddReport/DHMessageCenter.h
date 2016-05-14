//
//  DHMessageCenter.h
//  DriverHelper
//
//  Created by Gordon Su on 16/5/6.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHMessageCenter : NSObject

+ (DHMessageCenter *)curCenter;

- (void)initServer;

- (void)pauseServer;

- (void)resumeServer;

@end
