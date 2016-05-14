//
//  SUIDate.h
//  SUIKit
//
//  Created by Gordon Su on 16/3/15.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <Foundation/Foundation.h>

enum { SUIDateDistantPast = NSIntegerMax };

@interface SUIDate : NSObject

+ (NSDate *)dateFromDayString:(NSString *)dayString timeString:(NSString *)timeString;

+ (NSString *)smartDescriptionWithDayString:(NSString *)dayString timeString:(NSString *)timeString maxRelativePastDays:(NSUInteger)maxRelativePastDays;

@end

@interface NSDate (SUIAdditions)

- (NSString *)sui_smartDescriptionWithMaxRelativePastDays:(NSUInteger)maxRelativePastDays;

- (NSString *)sui_smartDescriptionWithMaxRelativePastDays:(NSUInteger)maxRelativePastDays isDayMonthLevel:(BOOL)isDayMonthLevel;

@end

@interface SUIDateManager : NSObject

+ (SUIDateManager *)sharedManager;

- (NSDate *)dayAsDateFromString:(NSString *)string;
- (NSDate *)minuteAsDateFromString:(NSString *)string;
- (NSDate *)secondAsDateFromString:(NSString *)string;

- (NSString *)dayAsStringFromDate:(NSDate *)date;
- (NSString *)minuteAsStringFromDate:(NSDate *)date;
- (NSString *)secondAsStringFromDate:(NSDate *)date;

@end
