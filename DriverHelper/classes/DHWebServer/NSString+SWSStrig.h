//
//  NSString+SWSNSStrig.h
//  世界婴童网
//
//  Created by gordon on 16/3/4.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SWSStrig)

/**
 *  根据当前app测试开关转化API的测试或者生产地址
 *
 *  @param address <#address description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)sws_URLStringByTransformHostAddress:(NSString *)address;

@end
