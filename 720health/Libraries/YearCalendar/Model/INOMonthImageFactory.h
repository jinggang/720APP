//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import <Foundation/Foundation.h>

@class INOMonthGlyphsHelper;

@interface INOMonthImageFactory : NSObject

@property (nonatomic, strong) NSDictionary *colorsForEventCategories;

+ (INOMonthImageFactory *)sharedFactory;

- (UIImage *)monthImageWithDate:(NSDate *)monthDate ofSize:(CGSize)size;
- (UIImage *)monthImageWithDate:(NSDate *)monthDate ofSize:(CGSize)size eventsForDates:(NSDictionary *)eventsForDates;

- (void)resetFactory;

@end
