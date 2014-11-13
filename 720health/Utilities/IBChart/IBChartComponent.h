//
//  IBChartComponent.h
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBChartView.h"

@interface IBChartComponent : UIView

@property(strong,nonatomic)NSArray * points;//CGPoint的NSValue的数组，则线图的点的位置 从左到右
//如果在块状图中  则不一样  point的X表示 一个块的 X起点  Y表示 X终点。。。
@property(strong,nonatomic)IBChartView * chartView;//底框

-(id)initWithParentChartView:(IBChartView *)chartView;





@end
