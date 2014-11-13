//
//  KYAnalyseCell.h
//  720health
//
//  Created by rock on 14-10-30.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBChartView.h"
@interface KYAnalyseCell : UITableViewCell

-(instancetype)initStyleWithChartView:(IBChartView*)chartView;

@property(nonatomic,strong) IBChartView *chartView;
@end
