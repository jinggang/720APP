//
//  IBChartComponent.m
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "IBChartComponent.h"

@implementation IBChartComponent

-(id)initWithParentChartView:(IBChartView *)chartView
{
    self = [super initWithFrame:CGRectMake(chartView.data.marginLeft, chartView.data.marginTop, chartView.bounds.size.width - chartView.data.marginLeft - chartView.data.marginRight, chartView.bounds.size.height - chartView.data.marginTop - chartView.data.marginBottom)];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        _chartView = chartView;
        [chartView addSubview:self];
    }
    return self;
}


@end
