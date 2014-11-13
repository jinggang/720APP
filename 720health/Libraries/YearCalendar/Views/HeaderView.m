//
//  HeaderView.m
//  720health
//
//  Created by rock on 14-10-12.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "HeaderView.h"

#define DATE_LEAD_SPACING 20  //日历显示区域距边缘
#define DATE_TAIL_SPACING  20
@implementation HeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    float unitWidth = (ScreenWidth - DATE_LEAD_SPACING - DATE_TAIL_SPACING) / 7;
    UILabel *headLabel;
    for (int i = 0 ; i < 7; i++) {
        headLabel = [[UILabel alloc]initWithFrame:CGRectMake(DATE_LEAD_SPACING + i*unitWidth, 20, unitWidth,self.frame.size.height-20)];
        headLabel.backgroundColor = [UIColor clearColor];
        headLabel.font = [UIFont fontWithName:nil size:15];
        headLabel.textAlignment = NSTextAlignmentCenter;
        headLabel.textColor = [UIColor whiteColor];
        [self addSubview:headLabel];
        switch (i) {
            case 0:
                headLabel.text = @"日";
                break;
            case 1:
                headLabel.text = @"一";
                break;
            case 2:
                headLabel.text = @"二";
                break;
            case 3:
                headLabel.text = @"三";
                break;
            case 4:
                headLabel.text = @"四";
                break;
            case 5:
                headLabel.text = @"五";
                break;
            case 6:
                headLabel.text = @"六";
                break;
            default:
                break;
        }
    }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0,headLabel.frame.size.height+19 , ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_head_line.png"]];
    [self addSubview:line];
}


@end
