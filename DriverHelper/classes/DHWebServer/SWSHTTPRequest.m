//
//  SYSHTTPRequest.m
//  世界婴童网
//
//  Created by gordon on 16/3/3.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SWSHTTPRequest.h"
#import "SWSURL.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface SWSHTTPRequest ()

@property (nonatomic, strong) SWSURL *URL;

@end

@implementation SWSHTTPRequest

- (instancetype)initWithBaseUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _URL = [[SWSURL alloc] initWithUrl:url];
        _URL.request = self;
        _POST = YES;
        _needToShowNetWorkMsgOnStatuBar = YES;
        _additionalQueryDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)description
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    if (!self.POST) {
        [mutableString appendFormat:@"GET: %@", [self.URL buildString]];
    } else {
        [mutableString appendFormat:@"POST: %@", [self.URL base]];
        [mutableString appendFormat:@", queries: %@", [self.URL buildQueries]];
    }
    return mutableString;
}

- (void)setQueryValue:(id)value forKey:(NSString *)key
{
    if (value &&  ![value isKindOfClass:[NSNull class]]  && key && ![key isKindOfClass:[NSNull class]]) {
        [_additionalQueryDictionary setObject:value forKey:key];
    }
}

@end
