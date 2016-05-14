//
//  SWSURL.m
//  世界婴童网
//
//  Created by gordon on 16/3/4.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SWSURL.h"
#import "NSString+SWSStrig.h"
#import "SWSHTTPRequest.h"

NSString *const SWSURLBasicQueryAppKey         = @"appkey";
NSString *const SWSURLBasicQueryAppType        = @"apptype";
NSString *const SWSURLBasicQueryAppVersion     = @"appversion";

NSArray * SWSURLKeysOfDefaultBasicHeaderQueries()
{
    return @[
        SWSURLBasicQueryAppKey,
        SWSURLBasicQueryAppType,
        SWSURLBasicQueryAppVersion
    ];
}

@interface SWSURL ()

@property (nonatomic, copy) NSString *base;

@property (nonatomic, copy) NSDictionary *queries;

@end

@implementation SWSURL

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        NSAssert(url != nil, @"URL 的地址为空!");
//        url = [url sws_URLStringByTransformHostAddress:url];
        [self parseURL:url];
    }
    return self;
}

- (NSString *)buildString
{
    NSString *base = self.base;
    NSString *queryString = [self buildQueryString];

    if (!queryString || [@"" isEqualToString:queryString]) {
        return base;
    } else {
        return [NSString stringWithFormat:@"%@?%@", base, queryString];
    }
}

- (NSString *)buildQueryString
{
    NSDictionary *queries = self.buildQueries;
    
    NSArray *keys = [[queries allKeys] sortedArrayUsingSelector:@selector(compare:)]; // 按key的字母顺序排列参数
    
    NSMutableString *queryString = [[NSMutableString alloc] init];
    
    BOOL firstParamter = YES;
    
    for (NSString *key in keys) {
        NSString *value = [queries objectForKey:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        if (value) {
            if (firstParamter) {
                [queryString appendFormat:@"%@=%@", key, value];
            } else {
                [queryString appendFormat:@"&%@=%@", key, value];
            }
        }
        
        firstParamter = NO;
    }
    
    return queryString.copy;
}

- (void)parseURL:(NSString *)url
{
    if (!url) {
        _base = @"";
    }
    self.base = [NSString stringWithString:url];
    NSString *pStr = @"?";
    NSRange range = [url rangeOfString:pStr];

    if (range.location == NSNotFound) {
        return;
    } else {
        self.base = [url substringToIndex:range.location];
    }

    NSString *qs = [url substringFromIndex:range.location + 1];
    [self parseQueryStr:qs];
}

- (void)parseQueryStr:(NSString *)query
{
    _queries = [self queriesFromQueryString:query];
}

- (NSDictionary *)queriesFromQueryString:(NSString *)query
{
    if (query == nil || [query isEqualToString:@""]) {
        return nil;
    }

    NSRange r1 = [query rangeOfString:@"?"];

    if (r1.location != NSNotFound) {
        if (r1.location + 1 < [query length]) {
            query = [query substringFromIndex:r1.location + 1];
        } else {
            query = @"";
        }
    }

    NSMutableDictionary *queries = [[NSMutableDictionary alloc] init];
    NSArray *arr1 = [query componentsSeparatedByString:@"&"];
    if (arr1 == nil) {
        return nil;
    }

    NSString *t2;
    NSArray *arr2;
    for (t2 in arr1) {
        if ([t2 isEqualToString:@""]) {
            continue;
        }
        arr2 = [t2 componentsSeparatedByString:@"="];
        if ([arr2 count] == 1) {
            id theKey = [arr2 firstObject];
            if (theKey) {
                [queries setObject:@"" forKey:theKey];
            }
        } else if ([arr2 count] == 2) {
            id theKey = [arr2 firstObject];
            [queries setValue:[arr2 objectAtIndex:1] forKey:theKey];
        }
    }

    return queries;
}

- (NSDictionary *)buildQueries
{
    NSMutableDictionary *mutableQueries = [NSMutableDictionary dictionaryWithDictionary:self.queries];
    for (NSString *key in self.request.queries) {
        id value  = [self.request.queries objectForKey:key];
        [mutableQueries setValue:value forKey:key];
    }
    
    for (NSString *key in self.request.additionalQueryDictionary) {
        id value  = [self.request.additionalQueryDictionary objectForKey:key];
        [mutableQueries setValue:value forKey:key];
    }
    
    return mutableQueries.copy;
}

@end
