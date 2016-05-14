//
//  UIImage+DHImageExt.h
//  DriverHelper
//
//  Created by Gordon Su on 16/4/24.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DHImageExt)

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
