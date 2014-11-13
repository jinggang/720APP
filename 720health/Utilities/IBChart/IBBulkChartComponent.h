//
//  IBBulkChartComponent.h
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "IBChartComponent.h"

@class IBBulkChartComponentDelegate;

@interface IBBulkChartComponent : IBChartComponent


@property(strong,nonatomic)UIColor * bulkColor;//块的颜色
@property(assign,nonatomic)CGFloat bulkMarginTop;//块离上边的距离
@property(assign,nonatomic)CGFloat bulkMarginBottom;//块离下边的距离

@property(strong,nonatomic)UIView * cursor;//指针
@property(strong,nonatomic)UIColor * cursorColor;//指针颜色

@property(assign,nonatomic)id delegate;//delegate


@end

@protocol IBBulkChartComponentDelegate
@required
-(void)updataValue:(BOOL)value withComponent:(IBBulkChartComponent *)component;
@end
