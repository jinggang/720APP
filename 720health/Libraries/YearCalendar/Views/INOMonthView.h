//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface INOMonthView : UIView
@property (nonatomic, strong) NSDate *monthDate;
- (void)setupWithMonthDate:(NSDate *)monthDate;
- (void)setupWithMonthImage:(UIImage *)monthImage;

@end
