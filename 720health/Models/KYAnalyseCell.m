//
//  KYAnalyseCell.m
//  720health
//
//  Created by rock on 14-10-30.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "KYAnalyseCell.h"

@implementation KYAnalyseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(instancetype)initStyleWithChartView:(IBChartView*)chartView{
    self.frame = CGRectMake(0, 0, ScreenWidth, chartView.frame.size.height+20);
    chartView.center = self.center;
    [self.contentView addSubview:chartView];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
