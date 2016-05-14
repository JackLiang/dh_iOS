//
//  SYSHTTPRequest.h
//  世界婴童网
//
//  Created by gordon on 16/3/3.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWSURL;

@interface SWSHTTPRequest : NSObject

@property (nonatomic, readonly) SWSURL *URL;

@property (nonatomic, copy) NSDictionary *queries;

@property (nonatomic, strong, readonly) NSMutableDictionary *additionalQueryDictionary;

@property (nonatomic, copy) NSData *fileData;//upload
/**
 *  时候要在状态栏显示网络返回信息，default YES
 */
@property (nonatomic) BOOL needToShowNetWorkMsgOnStatuBar;

/**
 *  default NO
 */
@property (nonatomic, getter = isPost) BOOL POST;

- (instancetype)initWithBaseUrl:(NSString *)url;

- (void)setQueryValue:(id)value forKey:(NSString *)key;

@end
