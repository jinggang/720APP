//
//  IBLineChartComponent.h
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "IBChartComponent.h"


@class IBLineChartComponentDelegate;

@interface IBLineChartComponent : IBChartComponent

@property(strong,nonatomic)UIColor * lineColor;//折线的颜色
@property(assign,nonatomic)CGFloat lineWidth;//折线的粗细
@property(strong,nonatomic)UIColor * pointColor;//点的颜色
@property(assign,nonatomic)CGFloat pointRadius;//点的半径
@property(strong,nonatomic)UIView * cursor;//那个标尺
@property(strong,nonatomic)UIColor * cursorColor;//标尺的颜色
@property(strong,nonatomic)UILabel * pointText;//点的文字
@property(strong,nonatomic)UIColor * fillColor;//半透明的填充颜色
@property(assign,nonatomic)BOOL pointTextHidden;//是否显示点的文字

@property(assign,nonatomic)id delegate;//  delegate

@end


@protocol IBLineChartComponentDelegate
@required
-(void)updataValue:(CGFloat)value withLineComponent:(IBLineChartComponent *)component;
@end
