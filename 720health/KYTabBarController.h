//
//  KYTabBarController.h
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//  外层页面框架 tabBarController

#import <UIKit/UIKit.h>

@interface KYTabBarController : UITabBarController

@property(nonatomic, weak)  UIViewController *plusController;
@property(nonatomic, weak)  UIButton *centerButton;

@property(nonatomic, assign) BOOL tabBarHidden;

-(void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;
@end
