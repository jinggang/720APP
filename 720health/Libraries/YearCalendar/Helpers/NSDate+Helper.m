//
//  NSDate+Helper.m
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+(NSInteger) weekdayOfFirstDateOfCurrentMonth
{
    
    //Get gregorian calendar
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //Today's date
    NSDate *today = [NSDate date];
    
    //Weekday components
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
    
    //Set date to first day of the month
    [weekdayComponents setDay:1];
    
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:weekdayComponents];
    
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday) fromDate:firstDayOfMonthDate];
    
    NSInteger weekday = [comp weekday];
    //Return the weekday
    return weekday;
}

#pragma mark 根据选中的年月计算相关的数据
+ (int)getDayCountOfMonth:(int)month andYear:(int)year
{
    switch (month) {
        case 1:
            return 31;
        case 3:
            return 31;
        case 4:
            return 30;
        case 5:
            return 31;
        case 6:
            return 30;
        case 7:
            return 31;
        case 8:
            return 31;
        case 9:
            return 30;
        case 10:
            return 31;
        case 11:
            return 30;
        case 12:
            return 31;
        default:
            break;
    }
    if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
    {
        return 29;
    }
    else {
        return 28;
    }
}

+ (int)getStartNumber:(int)month andYear:(int)year
{
    int baseNumber;		// 基数
    int startNumberT;	// 周几开始
    // 闰年
    if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
    {
        switch (month) {
            case 1:
                baseNumber = 0;
                break;
            case 2:
                baseNumber = 3;
                break;
            case 3:
                baseNumber = 4;
                break;
            case 4:
                baseNumber = 0;
                break;
            case 5:
                baseNumber = 2;
                break;
            case 6:
                baseNumber = 5;
                break;
            case 7:
                baseNumber = 0;
                break;
            case 8:
                baseNumber = 3;
                break;
            case 9:
                baseNumber = 6;
                break;
            case 10:
                baseNumber = 1;
                break;
            case 11:
                baseNumber = 4;
                break;
            case 12:
                baseNumber = 6;
                break;
            default:
                break;
        }
        startNumberT = (year + year/4 + year/400 - year/100 - 2 + baseNumber + 1) % 7;
    }
    // 平年
    else
    {
        switch (month) {
            case 1:
                baseNumber = 0;
                break;
            case 2:
                baseNumber = 3;
                break;
            case 3:
                baseNumber = 3;
                break;
            case 4:
                baseNumber = 6;
                break;
            case 5:
                baseNumber = 1;
                break;
            case 6:
                baseNumber = 4;
                break;
            case 7:
                baseNumber = 6;
                break;
            case 8:
                baseNumber = 2;
                break;
            case 9:
                baseNumber = 5;
                break;
            case 10:
                baseNumber = 0;
                break;
            case 11:
                baseNumber = 3;
                break;
            case 12:
                baseNumber = 5;
                break;
            default:
                break;
        }
        startNumberT = (year + year/4 + year/400 - year/100 - 1 + baseNumber + 1) % 7;
    }
    return startNumberT;
}


@end
