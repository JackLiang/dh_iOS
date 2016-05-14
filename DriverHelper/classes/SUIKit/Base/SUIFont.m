//
//  UIFont+SUIFont.m
//  syshop
//
//  Created by Gordon Su on 16/4/20.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SUIFont.h"

NSString *const SUIFontNameSourceHanSansCNNormal = @"SourceHanSansCN-Normal";
NSString *const SUIFontNameSourceHanSansCNRegular = @"SourceHanSansCN-Regular";
NSString *const SUIFontNameSourceHanSansCNLight = @"SourceHanSansCN-Light";

@implementation UIFont (SUIFont)

+ (UIFont *)sui_boldFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:SUIFontNameSourceHanSansCNRegular size:fontSize];
}

+ (UIFont *)sui_regularFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:SUIFontNameSourceHanSansCNNormal size:fontSize];
}

@end
