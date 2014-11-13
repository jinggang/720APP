//
//  MainCell.h
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainCell : UITableViewCell

-(instancetype)initStyleWithData:(NSArray*)array;//根据数据设置样式

-(instancetype)removeStyleFromIndex:(int)index;//清除所有样式  从cell中的第index个元素开始

@property(weak,nonatomic) NSArray *cellInfoArr;//这一个cell的数据源

@property(strong,nonatomic) NSMutableArray *labelArray;//这一个cell的所有的UILabel
@property(strong,nonatomic) NSMutableArray *radiaArray;//这一个cell的所有的圆圈
@property(strong,nonatomic) NSMutableArray *dotArray;//这一个cell的所有的红点
@end
