//
//  SUIDate.m
//  SUIKit
//
//  Created by Gordon Su on 16/3/15.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SUIDate.h"

#define M_MINUTE 60.f
#define M_HOUR   (M_MINUTE * 60.f)
#define M_DAY    (M_HOUR * 24.f)

@interface SUIDateManager ()

@property NSDateFormatter *secondLevelDateFormater;
@property NSDateFormatter *minuteLevelDateFormater;
@property NSDateFormatter *dayLevelDateFormater;
@property NSDateFormatter *dayMonthLevelDateFormater;

@property NSRecursiveLock *secondLevelDateFormaterLock;
@property NSRecursiveLock *minuteLevelDateFormaterLock;
@property NSRecursiveLock *dayLevelDateFormaterLock;
@property NSRecursiveLock *dayMonthLevelDateFormaterLock;

@end

@implementation SUIDateManager

+ (SUIDateManager *)sharedManager {
    static SUIDateManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager =  [[SUIDateManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];

    if (self) {
        _secondLevelDateFormater =  [[NSDateFormatter alloc] init];
        [_secondLevelDateFormater setDateFormat:@"yyyy-M-d H:m:s"];

        _minuteLevelDateFormater = [[NSDateFormatter alloc] init];
        [_minuteLevelDateFormater setDateFormat:@"yyyy-M-d H:m"];

        _dayLevelDateFormater = [[NSDateFormatter alloc] init];
        [_dayLevelDateFormater setLocale:[NSLocale currentLocale]];
        [_dayLevelDateFormater setDateFormat:@"yyyy-M-d"];
        
        _dayMonthLevelDateFormater = [[NSDateFormatter alloc] init];
        [_dayMonthLevelDateFormater setLocale:[NSLocale currentLocale]];
        [_dayMonthLevelDateFormater setDateFormat:@"M-d"];

        _secondLevelDateFormaterLock = [[NSRecursiveLock alloc] init];
        _minuteLevelDateFormaterLock = [[NSRecursiveLock alloc] init];
        _dayLevelDateFormaterLock = [[NSRecursiveLock alloc] init];
        _dayMonthLevelDateFormaterLock = [[NSRecursiveLock alloc] init];
    }
    
    return self;
}

- (NSDate *)dayAsDateFromString:(NSString *)string {
    [self.dayLevelDateFormaterLock lock];
    NSDate *final = [self.dayLevelDateFormater dateFromString:string];
    [self.dayLevelDateFormaterLock unlock];

    return final;
}

- (NSDate *)minuteAsDateFromString:(NSString *)string {
    [self.minuteLevelDateFormaterLock lock];
    NSDate *final = [self.minuteLevelDateFormater dateFromString:string];
    [self.minuteLevelDateFormaterLock unlock];

    return final;
}

- (NSDate *)secondAsDateFromString:(NSString *)string {
    [self.secondLevelDateFormaterLock lock];
    NSDate *final = [self.secondLevelDateFormater dateFromString:string];
    [self.secondLevelDateFormaterLock unlock];

    return final;
}

- (NSString *)dayAsStringFromDate:(NSDate *)date {
    [self.dayLevelDateFormaterLock lock];
    NSString *final = [self.dayLevelDateFormater stringFromDate:date];
    [self.dayLevelDateFormaterLock unlock];

    return final;
}

- (NSString *)dayMonthAsStringFromDate:(NSDate *)date {
    [self.dayMonthLevelDateFormaterLock lock];
    NSString *final = [self.dayMonthLevelDateFormater stringFromDate:date];
    [self.dayMonthLevelDateFormaterLock unlock];
    
    return final;
}

- (NSString *)minuteAsStringFromDate:(NSDate *)date {
    [self.minuteLevelDateFormaterLock lock];
    NSString *final = [self.minuteLevelDateFormater stringFromDate:date];
    [self.minuteLevelDateFormaterLock unlock];

    return final;
}

- (NSString *)secondAsStringFromDate:(NSDate *)date {
    [self.secondLevelDateFormaterLock lock];
    NSString *final = [self.secondLevelDateFormater stringFromDate:date];
    [self.secondLevelDateFormaterLock unlock];

    return final;
}

@end

@implementation SUIDate

+ (NSDate *)dateFromDayString:(NSString *)dayString timeString:(NSString *)timeString {
    if (![dayString length]) {
        return nil;
    }

    NSString *dateString = nil;

    if ([dayString length] > 11) {
        dateString = dayString;
    } else {
        dateString = [NSString stringWithFormat:@"%@ %@", dayString, [timeString length] ? timeString : @"00:00:01"];
    }


    NSDate *date = [[SUIDateManager sharedManager] secondAsDateFromString:dateString];
    if (!date) {
        date = [[SUIDateManager sharedManager] minuteAsDateFromString:dateString];
    }
    if (!date) {
        date = [[SUIDateManager sharedManager] dayAsDateFromString:dateString];
    }

    return date;
}

+ (NSString *)smartDescriptionWithDayString:(NSString *)dayString timeString:(NSString *)timeString maxRelativePastDays:(NSUInteger)maxRelativePastDays {
    NSDate *date = [self dateFromDayString:dayString timeString:timeString];

    return date ? [date sui_smartDescriptionWithMaxRelativePastDays:maxRelativePastDays] : @"";
}

@end


@implementation NSDate (SUIAdditions)

- (NSString *)sui_smartDescriptionWithMaxRelativePastDays:(NSUInteger)maxRelativePastDays {

    
    return [self sui_smartDescriptionWithMaxRelativePastDays:maxRelativePastDays isDayMonthLevel:NO];
}

- (NSString *)sui_smartDescriptionWithMaxRelativePastDays:(NSUInteger)maxRelativePastDays isDayMonthLevel:(BOOL)isDayMonthLevel {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self];
    
    if (timeInterval < 60.0) {
        return @"刚刚";
    }
    
    NSString *finalString = nil;
    
    if (timeInterval < 0) {
        if (isDayMonthLevel) {
            finalString = [[SUIDateManager sharedManager] dayMonthAsStringFromDate:self];
        }
        else{
            finalString = [[SUIDateManager sharedManager] dayAsStringFromDate:self];
        }
        
    } else {
        if (timeInterval < M_HOUR) {
            finalString = [NSString stringWithFormat:@"%.0f分钟前", floorf(timeInterval / M_MINUTE)];
        } else if (timeInterval < M_DAY) {
            finalString = [NSString stringWithFormat:@"%.0f小时前", floorf(timeInterval / M_HOUR)];
        } else if (timeInterval < M_DAY * maxRelativePastDays) {
            finalString = [NSString stringWithFormat:@"%.0f天前", floorf(timeInterval / M_DAY)];
        } else {
            if (isDayMonthLevel) {
                finalString = [[SUIDateManager sharedManager] dayMonthAsStringFromDate:self];
            }
            else{
                finalString = [[SUIDateManager sharedManager] dayAsStringFromDate:self];
            }
        }
    }
    
    if (finalString == nil) {
        return @"";
    }
    
    return finalString;
}


@end