//
//  MainCell.m
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "MainCell.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressLabel.h"
#import "MDRadialProgressTheme.h"

#define DATE_LEAD_SPACING 20  //日历显示区域距边缘
#define DATE_TAIL_SPACING  20

@implementation MainCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {}
    return self;
}

-(instancetype)initStyleWithData:(NSArray*)array
{
        self.labelArray = [[NSMutableArray alloc]init];
        float unitWidth = (ScreenWidth - DATE_LEAD_SPACING - DATE_TAIL_SPACING) / 7;
        for (int i = 0 ; i < 7; i++) {
            NSDictionary *dic = [self.cellInfoArr objectAtIndex:i];
            UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(DATE_LEAD_SPACING + i*unitWidth, 12, unitWidth,self.contentView.frame.size.height)];
            //添加外围圆弧样式
            MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
            newTheme.completedColor = CalendarRadiaCircleColor;
            newTheme.incompletedColor = [UIColor clearColor];
            newTheme.centerColor = CalendarCenterCircleColor;
            newTheme.sliceDividerHidden = YES;
            newTheme.labelColor = [UIColor colorWithRed:20/255.0 green:147/255.0 blue:173/255.0 alpha:1.0];//不显示默认的数字
            newTheme.dropLabelShadow = NO;
            newTheme.thickness = 7;//外圆圈的厚度
            float margin = 3;
            CGRect frame = CGRectMake(margin, 3, dateView.frame.size.width-2*margin+3, dateView.frame.size.width-2*margin);
            //添加用于显示日期的label
            UILabel *dateNumLabel = [[UILabel alloc]initWithFrame:frame];//用来显示日期的控件
            dateNumLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"dateString"]];
            dateNumLabel.textAlignment = NSTextAlignmentCenter;
            dateNumLabel.textColor = [UIColor whiteColor];
            dateNumLabel.backgroundColor = [UIColor clearColor];
            dateNumLabel.userInteractionEnabled = YES;
            dateNumLabel.tag = i;
            [self.labelArray addObject:dateNumLabel];
            
            //创建并添加外围圆弧
            MDRadialProgressView *rView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
            rView.progressTotal = 100;//圆弧中进度
            rView.progressCounter = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"data"] valueForKey:@"progress"]].integerValue;//圆弧完成进度
            [self.radiaArray addObject:rView];
            
            //创建并添加下方红色圆点
            UIImageView *redDot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot.png"]];
            redDot.frame = CGRectMake((frame.size.width-5)/2+margin,frame.size.height+7, 5, 5);
            redDot.hidden = YES;
            [self.dotArray addObject:redDot];
            
            NSString *str = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"data"] valueForKey:@"isHealth"]];
            if ([str isEqualToString:@"1"]) {//生理警告 , 显示红点
                redDot.hidden = NO;
            }
            [dateView addSubview:redDot];
            [dateView addSubview:rView];
            [dateView addSubview:dateNumLabel];
            
            if (((NSNumber*)[dic valueForKey:@"isAfter"]).intValue ==  1 ) {//在今天之后 清除样式
                [redDot removeFromSuperview];
                [rView removeFromSuperview];
                dateNumLabel.textColor = [UIColor grayColor];
                dateNumLabel.userInteractionEnabled = NO;
            }
            [self.contentView addSubview:dateView];
    }
    return self;
}

-(instancetype)removeStyleFromIndex:(int)index
{
    for (int i = index; i < 7; i++) {
        ((UILabel*)self.labelArray[i]).textColor = [UIColor lightGrayColor];
        [self.radiaArray[i] removeFromSuperview];
        [self.dotArray[i] removeFromSuperview];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end


