//
//  世界婴童网
//
//  Created by gordon on 16/3/4.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SUIAdditions)

CGFloat SUIOnePixelToPoint(void);

- (void)sui_setOrigin:(CGPoint)origin;

- (void)sui_setSize:(CGSize)size;

- (void)sui_addBorderWithColor:(UIColor *)color;

- (void)sui_addBorderWithColor:(UIColor *)color width:(CGFloat)width;

- (void)sui_sizeToFitSize:(CGSize)size;

- (UITableViewCell *)sui_parentTableViewCell;

- (UIImage *)sui_snapshotImage;

@end
