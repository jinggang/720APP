//
//  IBChartView.h
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBChartViewDataItem : NSObject
@property(assign,nonatomic)CGFloat xMax; //X轴的数值 最大值
@property(assign,nonatomic)CGFloat xInterval; //X轴的数值的 间隔个数
@property(assign,nonatomic)CGFloat yMax; //Y轴同上
@property(assign,nonatomic)CGFloat yInterval; //Y轴同上 目前没有作用

@property(strong,nonatomic)NSArray * xAxesDegreeTexts;//X轴上的文字的数组 NSString类型 如果为nil则自动使用坐标X轴数字代替
@property(assign,nonatomic)CGFloat degreeMarginHorizon;//Y轴同上 没有作用


@property(assign,nonatomic)CGFloat cornerRadius; //外边框的 圆角半径

@property(strong,nonatomic)UIColor * borderColor; //外边框的 线条颜色
@property(assign,nonatomic)CGFloat borderWidth; //外边框的 线条粗细
@property(strong,nonatomic)UIColor * backgroundColor;//背景色
@property(strong,nonatomic)UIColor * dividingLineColor;//上下分割线的颜色
@property(assign,nonatomic)CGFloat fontSize;//默认字体大小
@property(strong,nonatomic)UIColor * fontColor;//默认字体颜色

@property(assign,nonatomic)CGFloat marginTop;//上分割线到上边的距离
@property(assign,nonatomic)CGFloat marginBottom;//下分割线到下边的距离
@property(assign,nonatomic)CGFloat marginLeft;//分割线到左边的距离
@property(assign,nonatomic)CGFloat marginRight;//分割线到右边的距离
@property(strong,nonatomic)NSArray * cutLineLevels;//中间的虚线的位置 其实为Y轴的位置 是一个NSNumber类型的数组
@property(strong,nonatomic)NSArray * cutLineColors;//中间的虚线的颜色  和上边对应  数组个数应该为一样的 是一个UIColor的数组


@end

@interface IBChartView : UIView

@property(strong,nonatomic)UIView * TLView;//左上角的视图
@property(strong,nonatomic)UIView * TRView;//右上角的视图

@property(strong,nonatomic)IBChartViewDataItem * data;//上边一大块的数据的数据类型

-(id)initWithFrame:(CGRect)frame dataItem:(IBChartViewDataItem *) data;//初始化函数   那个data后期也可以再次设置

@end
