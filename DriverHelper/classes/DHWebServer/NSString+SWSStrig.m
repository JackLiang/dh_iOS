//
//  NSString+SWSNSStrig.m
//  世界婴童网
//
//  Created by gordon on 16/3/4.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "NSString+SWSStrig.h"

@implementation NSString (SWSStrig)

- (NSString *)sws_URLStringByTransformHostAddress:(NSString *)address
{
    static NSString *regexHostNamePattern = @"^http(?:s)?:\\/\\/([^\\/]+)";
    if ([address length]) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexHostNamePattern
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
        if (match && [match numberOfRanges] > 1) {
            NSRange matchRange = [match rangeAtIndex:1];
//            if ([SYSDebugSettingManager isDebugEnvironment]) {
//                return [self stringByReplacingCharactersInRange:matchRange withString:API_TESTING_HOST];
//            } else {
//                return [self stringByReplacingCharactersInRange:matchRange withString:API_PRODUCTION_HOST];
//            }
        }
    }
    return self.copy;
}

@end
