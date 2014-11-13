//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface INOYearTableCell : UITableViewCell

@property (nonatomic, assign, getter = isLoadingInProgress) BOOL loadingInProgress;

- (void)setupWithYearDate:(NSDate *)yearDate;
- (void)setupWithMonthsImages:(NSArray *)monthsImages;

+ (CGFloat)cellHeight;
+ (CGSize)monthViewSize;

@end
