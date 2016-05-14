//
//  UIButton+SUIButton.m
//  syshop
//
//  Created by Gordon Su on 16/4/22.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SUIButton.h"

@implementation SUIButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    
    CGFloat widthDelta = self.expandRange - bounds.size.width;
    
    CGFloat heightDelta = self.expandRange - bounds.size.height;
    
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);//注意这里是负数，扩大了之前的bounds的范围
    
    return CGRectContainsPoint(bounds, point);
}

@end
