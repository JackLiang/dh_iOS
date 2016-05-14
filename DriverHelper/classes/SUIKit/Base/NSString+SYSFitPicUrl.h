//
//  NSString+SYSFitPicUrl.h
//  syshop
//
//  Created by Gordon Su on 16/4/25.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  IS_iPhone6P_WIDTH  ([UIScreen mainScreen].bounds.size.width == 414 ? YES : NO)
#define  IS_iPhone6_WIDTH   ([UIScreen mainScreen].bounds.size.width == 375 ? YES : NO)
#define  IS_iPhone4_5_WIDTH ([UIScreen mainScreen].bounds.size.width == 320 ? YES : NO)

@interface NSString (SYSFitPicUrl)

- (NSString *)getFitPicUrl;

@end
