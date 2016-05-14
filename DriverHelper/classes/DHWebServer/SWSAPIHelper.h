//
//  SYSAPIHelper.h
//  世界婴童网
//
//  Created by gordon on 16/3/3.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWSHTTPRequest;
@class SWSHTTPResponse;

typedef void (^SWSHTTPDownloadProgress)(NSProgress *downloadProgress);
typedef void (^SWSHTTPResponseSucceedHandler)(SWSHTTPResponse *respone);

@interface SWSAPIHelper : NSObject

//@property (nonatomic) BOOL asynchronous;

+ (instancetype)defaultHelper;

/**
 *  同步方法
 *
 *  @param request <#request description#>
 *
 *  @return <#return value description#>
 */
- (SWSHTTPResponse *)callRequest:(SWSHTTPRequest *)request;

- (SWSHTTPResponse *)callRequestWithUrl:(NSString *)url;

/**
 *  异步方法
 *
 *  @param request       <#request description#>
 *  @param finishHandler <#finishHandler description#>
 */
- (void)startAsynchronousWithRequest:(SWSHTTPRequest *)request progress:(SWSHTTPDownloadProgress)progress finish:(SWSHTTPResponseSucceedHandler)finishHandler;

- (void)uploadFileWithRequest:(SWSHTTPRequest *)request progress:(SWSHTTPDownloadProgress)progress finish:(SWSHTTPResponseSucceedHandler)finishHandler;

/**
 *  tong bu
 *
 *  @param request <#request description#>
 *
 *  @return <#return value description#>
 */
- (SWSHTTPResponse *)uploadFileWithRequest:(SWSHTTPRequest *)request;

@end
