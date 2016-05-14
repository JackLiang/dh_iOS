//
//  SWSURL.h
//  世界婴童网
//
//  Created by gordon on 16/3/4.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWSHTTPRequest;

/**
 *  基本的HTTP头部参数KEY值集合
 *
 *  @return <#return value description#>
 */
extern NSArray * SWSURLKeysOfDefaultBasicHeaderQueries(void);

@interface SWSURL : NSObject

@property (nonatomic, copy, readonly) NSString *base;

//@property (nonatomic, copy, readonly) NSDictionary *queries;

@property (nonatomic, weak) SWSHTTPRequest *request;

- (instancetype)initWithUrl:(NSString *)url;

- (NSString *)buildString;

- (NSDictionary *)buildQueries;

//+ (NSDictionary *)buildBaseHeaderQueries;



@end
