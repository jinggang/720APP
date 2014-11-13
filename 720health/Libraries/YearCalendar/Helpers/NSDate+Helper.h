//
//  NSDate+Helper.h
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDate (Helper)

+(NSInteger) weekdayOfFirstDateOfCurrentMonth;
+ (int)getDayCountOfMonth:(int)month andYear:(int)year;
+ (int)getStartNumber:(int)month andYear:(int)year;
@end
