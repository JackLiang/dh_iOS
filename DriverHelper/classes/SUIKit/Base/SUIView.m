//
//  SUIView.m
//  SUIKit
//  世界婴童网
//
//  Created by gordon on 16/3/4.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SUIView.h"
#import <QuartzCore/QuartzCore.h>

@interface UIView ()

- (void)sui_themeDidMoveToSuperview;

@end

@implementation UIView (SUIAdditions)

CGFloat SUIOnePixelToPoint(void)
{
    static CGFloat onePixelWidth = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onePixelWidth = 1.f / [UIScreen mainScreen].scale;
    });

    return onePixelWidth;
}

- (void)sui_setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)sui_setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)sui_addBorderWithColor:(UIColor *)color
{
    [self sui_addBorderWithColor:color width:1.f];
}

- (void)sui_addBorderWithColor:(UIColor *)color width:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)sui_sizeToFitSize:(CGSize)size
{
    CGSize toSize = [self sizeThatFits:size];
    CGRect bounds = self.bounds;
    bounds.size = toSize;
    self.bounds = bounds;
}

- (UITableViewCell *)sui_parentTableViewCell
{
    id superview = self.superview;
    if (superview) {
        if ([superview isKindOfClass:[UITableViewCell class]]) {
            return superview;
        } else {
            return [superview sui_parentTableViewCell];
        }
    }
    return nil;
}

- (UIImage *)sui_snapshotImage
{
    CGRect rect = self.bounds;

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();

    [self.layer renderInContext:context];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end
