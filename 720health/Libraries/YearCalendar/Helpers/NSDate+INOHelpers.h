//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDate (INOHelpers)

@property (nonatomic, readonly) NSCalendar *calendar;

- (NSDate *)clippedDateWithCalendarUnits:(NSCalendarUnit)calendarUnit;

- (NSDate *)dateByAddingValue:(NSUInteger)value forDateKey:(NSString *)key;

- (NSUInteger)daysInMonth;

- (NSUInteger)dayOfWeek;

- (NSDate *)beginningOfDay;
- (NSDate *)endOfDay;

- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;

- (NSDate *)beginningOfYear;
- (NSDate *)endOfYear;

@end
