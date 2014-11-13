//
//  KYECLController.m
//  720health
//
//  Created by rock on 14-11-5.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "KYECLController.h"

#define ButtomTabBarHight 90
#define BnttomTabBarItemHeight 60
@interface KYECLController ()

@end

@implementation KYECLController
{
    NSArray * imgNames;
    SLCoverFlowView * tabBar;
}
-(void)loadView
{
    [super loadView];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    imgNames = @[@"bushu",@"huanjingShushi",@"huanjingweihai",@"maibo_ball",@"rizhaoliang",@"shuimianzhiliang",@"tibiaowendu",@"xinfugan",@"yinshituijian"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1 delay:0 options:nil animations:^{
        tabBar = [[SLCoverFlowView alloc]initWithFrame:CGRectMake(0,ScreenHeight - ButtomTabBarHight, self.view.frame.size.width, ButtomTabBarHight)];
        tabBar.backgroundColor = [UIColor whiteColor];
        tabBar.delegate = self;
        
        tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tabBar.coverSize = CGSizeMake(BnttomTabBarItemHeight, BnttomTabBarItemHeight);
        tabBar.coverAngle = 0;
        tabBar.coverScale = 1.4;
        tabBar.coverSpace = 16;
        
        [self.view addSubview:tabBar];
        [tabBar reloadData];

    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:2 animations:^{
//            tabBar.frame = CGRectMake(0,ScreenHeight - ButtomTabBarHight, self.view.frame.size.width, ButtomTabBarHight);
//        } completion:^(BOOL finished) {
//        }];
    }];
}

#pragma mark - KYCoverTabBarDataSource

-(NSInteger)numberOfCovers:(SLCoverFlowView *)coverFlowView
{
    return imgNames.count;
}

-(SLCoverView *)coverFlowView:(SLCoverFlowView *)coverFlowView coverViewAtIndex:(NSInteger)index
{
    SLCoverView * view = [[SLCoverView alloc]initWithFrame:CGRectMake(0, 0, BnttomTabBarItemHeight, BnttomTabBarItemHeight)];
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imgNames objectAtIndex:index]]];
    imgView.frame = view.bounds;
    [view addSubview: imgView];
    return view;
}

@end
