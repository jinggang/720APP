//
//  FooterView.m
//  720health
//
//  Created by rock on 14-10-31.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "FooterView.h"

#define LEAD_SPACING 20  //日历显示区域距边缘
#define TAIL_SPACING  20

@implementation FooterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    float unitWidth = (ScreenWidth - LEAD_SPACING - TAIL_SPACING) / 3;
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(LEAD_SPACING, 0, unitWidth,self.frame.size.height)];
    //创建并添加下方红色圆点
    UIImageView *redDot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot.png"]];
    redDot.frame = CGRectMake(LEAD_SPACING,20, 5, 5);
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(redDot.frame.origin.x+5, 15, 60, 40)];
    firstLabel.text = @"生理告警";
    firstLabel.textColor = [UIColor whiteColor];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.font = [UIFont fontWithName:nil size:12.0];
    [firstView addSubview:redDot];
    [firstView addSubview:firstLabel];
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(LEAD_SPACING + unitWidth, 0, unitWidth,self.frame.size.height)];
    //创建并添加下方红色圆点
    UIImageView *blueDot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot_circle.png"]];
    blueDot.frame = CGRectMake((secondView.frame.size.width-65)/2-LEAD_SPACING,15, 20, 20);
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(blueDot.frame.origin.x+27.5, 15, 90, 30)];
    secondLabel.text = @"环境告警";
    secondLabel.textColor = [UIColor whiteColor];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.font = [UIFont fontWithName:nil size:12.0];
    [secondView addSubview:blueDot];
    [secondView addSubview:secondLabel];
    
    UIView *threeView = [[UIView alloc]initWithFrame:CGRectMake(LEAD_SPACING + 2*unitWidth, 0, unitWidth,self.frame.size.height)];
    //创建并添加下方红色圆点
    UIImageView *radiaDot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot_arc.png"]];
    radiaDot.frame = CGRectMake((threeView.frame.size.width-85)/2-LEAD_SPACING,15, 20, 20);
    UILabel *threeLabel = [[UILabel alloc]initWithFrame:CGRectMake(radiaDot.frame.origin.x+27.5, 15, 110, 30)];
    threeLabel.text = @"运动指标完成度";
    threeLabel.textColor = [UIColor whiteColor];
    threeLabel.textAlignment = NSTextAlignmentCenter;
    threeLabel.font = [UIFont fontWithName:nil size:12.0];
    [threeView addSubview:radiaDot];
    [threeView addSubview:threeLabel];

    self.backgroundColor = [UIColor clearColor];
    [self addSubview:firstView];
    [self addSubview:secondView];
    [self addSubview:threeView];
}


@end
