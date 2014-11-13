//
//  KYHorizontalScrollTabBar.h
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KYCoverTabBar;

@protocol KYCoverTabBarDataSource

-(NSInteger)numberOfViews:(KYCoverTabBar *)tabbar;
-(UIView *)coverTabBar:(KYCoverTabBar *)tabbar atIndex:(NSInteger)index;
@end

@interface KYCoverTabBar : UIView

@property(assign,nonatomic)id<KYCoverTabBarDataSource> dataSource;

@property(assign,nonatomic)CGSize itemSize;
@property(assign,nonatomic)CGFloat itemSpace;
@property(assign,nonatomic)CGFloat itemAngle;
@property(assign,nonatomic)CGFloat itemScale;

@property(assign,nonatomic,readonly)NSInteger numberOfViews;

-(void)reloadData;

-(UIView *)leftMostVisibleCoverView;
-(UIView *)rightMostVisibleCoverView;

@end

