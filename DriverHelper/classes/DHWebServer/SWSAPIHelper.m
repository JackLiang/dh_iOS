//
//  SYSAPIHelper.m
//  世界婴童网
//
//  Created by gordon on 16/3/3.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SWSAPIHelper.h"
#import "SWSHTTPRequest.h"
#import "SWSHTTPResponse.h"
#import "SWSURL.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit/JSONKit.h>

@interface SWSAPIHelper ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation SWSAPIHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)defaultHelper
{
    return [[self alloc] init];
}

- (AFHTTPSessionManager *)httpManager
{
    if (!_httpManager) {
        _httpManager = [[AFHTTPSessionManager alloc] init];
        // 设置请求格式
        _httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //
        [_httpManager.requestSerializer setValue:@"iOS-DH" forHTTPHeaderField:@"User-Agent"];

        //header
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    }
    return _httpManager;
}

- (SWSHTTPResponse *)callRequest:(SWSHTTPRequest *)request
{
    NSCAssert(![NSThread isMainThread],  @"不能在主线程发起网络请求");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block SWSHTTPResponse *resultResopne = nil;
    [self startAsynchronousWithRequest:request progress:^(NSProgress *downloadProgress) {
    } finish:^(SWSHTTPResponse *respone) {
        resultResopne = respone;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return resultResopne;
}

- (SWSHTTPResponse *)callRequestWithUrl:(NSString *)url
{
    SWSHTTPRequest *request = [[SWSHTTPRequest alloc] initWithBaseUrl:url];
    SWSHTTPResponse *response = [self callRequest:request];
    return response;
}

- (void)startAsynchronousWithRequest:(SWSHTTPRequest *)request progress:(SWSHTTPDownloadProgress)progress finish:(SWSHTTPResponseSucceedHandler)finishHandler
{
    AFHTTPSessionManager *httpManager = self.httpManager;

    __block SWSHTTPResponse *respone = nil;
    
    NSLog(@"%@", request.description);

    if (request.isPost) {
        [httpManager
         POST:request.URL.base
            parameters:request.URL.buildQueries
              progress:^(NSProgress *_Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            respone = [self creatResponeWithTask:task responseObject:responseObject error:nil];

            if (finishHandler) {
                finishHandler(respone);
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            respone = [self creatResponeWithTask:task responseObject:nil error:error];
            respone.code = SWSApiResponseStatFail;

            if (finishHandler) {
                finishHandler(respone);
            }
            
            NSLog(@"%@", respone.failDescription);
        }];
    } else {
        [httpManager GET:request.URL.buildString parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
        } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            respone =  [self creatResponeWithTask:task responseObject:responseObject error:nil];
            //
            if (finishHandler) {
                finishHandler(respone);
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            respone = [self creatResponeWithTask:task responseObject:nil error:error];
            respone.code = SWSApiResponseStatFail;

            if (finishHandler) {
                finishHandler(respone);
            }
            NSLog(@"%@", respone.failDescription);
        }];
    }
}

- (void)uploadFileWithRequest:(SWSHTTPRequest *)request progress:(SWSHTTPDownloadProgress)progress finish:(SWSHTTPResponseSucceedHandler)finishHandler
{
    __block SWSHTTPResponse *respone = nil;

    AFHTTPSessionManager *manager = self.httpManager;

    [manager POST:request.URL.base parameters:request.URL.buildQueries constructingBodyWithBlock:^(id < AFMultipartFormData > formData) {
        if (request.fileData) {
            [formData appendPartWithFileData:request.fileData name:@"file" fileName:@"imaage121" mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress *progres) {
        if (progress) {
            progress(progres);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        respone = [self creatResponeWithTask:task responseObject:responseObject error:nil];
        if (finishHandler) {
            finishHandler(respone);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self creatResponeWithTask:task responseObject:nil error:error];
        respone.code = SWSApiResponseStatFail;

        if (finishHandler) {
            finishHandler(respone);
        }
    }];
}

- (SWSHTTPResponse *)uploadFileWithRequest:(SWSHTTPRequest *)request
{
    NSCAssert(![NSThread isMainThread],  @"不能在主线程发起网络请求");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block SWSHTTPResponse *resultResopne = nil;
    [self uploadFileWithRequest:request progress:nil finish:^(SWSHTTPResponse *respone) {
        resultResopne = respone;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return resultResopne;
}

//- (void)fillBaseQueriesToHttpHeader:(AFHTTPSessionManager *)httpManager
//{
//    if (!httpManager) {
//        return;
//    }
//    NSDictionary *headerQueries = [SWSURL buildBaseHeaderQueries];
//    for (NSString *key in headerQueries) {
//        [httpManager.requestSerializer setValue:[headerQueries objectForKey:key] forHTTPHeaderField:key];
//    }
//}

- (SWSHTTPResponse *)creatResponeWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error
{
    SWSHTTPResponse *response = [[SWSHTTPResponse alloc] init];
    if (responseObject) {
        NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = [dataStr objectFromJSONString];
        response.dataDictionary = [dic objectForKey:@"object"];
        response.body = dataStr;
        response.code = [[dic objectForKey:@"code"] integerValue];
        response.msg = [dic objectForKey:@"msg"];
    }

    if (task) {
        NSData *data = task.originalRequest.HTTPBody;
        NSString *urlString = [task.originalRequest.URL absoluteString];
        NSString *requestBody = [data objectFromJSONData];
        NSMutableDictionary *requestJson = [[NSMutableDictionary alloc] init];
        requestJson[@"url"] = urlString;
        requestJson[@"requestBody"] = requestBody;
        response.requestBodyDictionary = [requestJson copy];
    }

    if (error) {
        response.error = error;
    }

    return response;
}

@end
