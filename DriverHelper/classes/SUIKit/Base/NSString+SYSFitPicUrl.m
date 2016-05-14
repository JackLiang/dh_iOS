//
//  NSString+SYSFitPicUrl.m
//  syshop
//
//  Created by Gordon Su on 16/4/25.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "NSString+SYSFitPicUrl.h"

@implementation NSString (SYSFitPicUrl)

- (NSString *)getFitPicUrl
{
    NSString *url = self;
    NSArray *array = [url componentsSeparatedByString:@"!"];
    if (array.count) {
        NSString *rawurl = array[0];
        if (IS_iPhone4_5_WIDTH) {
            rawurl = [NSString stringWithFormat:@"%@!640", rawurl];
        } else if (IS_iPhone6_WIDTH|| IS_iPhone6P_WIDTH) {
            return rawurl;
        }
    }
    return url;
}

@end
