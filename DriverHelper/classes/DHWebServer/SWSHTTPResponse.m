//
//  SYSHTTPResponse.m
//  世界婴童网
//
//  Created by gordon on 16/3/3.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SWSHTTPResponse.h"

@implementation SWSHTTPResponse

- (BOOL)isSuccess
{
    return _code == SWSApiResponseStatSuccess;
}

- (NSString *)failDescription
{
    return [NSString stringWithFormat:@"API Request Failed:\n URL: %@ \n :%@", self.requestBodyDictionary, self.error.localizedDescription];
}

@end
