//
//  DeatailCell.m
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import "DeatailCell.h"

@implementation DeatailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 30)];
        label.text = @"睡眠时间23:00      起床时间: 07:00";
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Blazed" size:12];
        self.contentView.backgroundColor = [UIColor grayColor];
        [self.contentView  addSubview:label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
