//
//  SYSHTTPResponse.h
//  世界婴童网
//
//  Created by gordon on 16/3/3.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, SWSApiResponseStat) {
    SWSApiResponseStatFail                   = -1, /**< 网络失败 */
    SWSApiResponseStatSuccess                = 0, /**< 成功 */
};

@interface SWSHTTPResponse : NSObject

@property (nonatomic) SWSApiResponseStat code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSError *error;
@property (nonatomic, copy) NSDictionary *dataDictionary;
@property (nonatomic, copy) NSDictionary *requestBodyDictionary;

- (BOOL)isSuccess;

- (NSString *)failDescription;

@end
