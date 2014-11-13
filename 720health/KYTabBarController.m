//
//  KYTabBarController.m
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//  

#import "KYTabBarController.h"
#import "KYTumblrMenuView.h"

@interface KYTabBarController ()

@end

@implementation KYTabBarController

@synthesize plusController;
@synthesize centerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"add_bar"] highlightImage:[UIImage imageNamed:@"add_bar"] target:self action:@selector(buttonPressed:)];
    
    self.tabBar.tintColor = KYTabBarTintColor;
    // 改变UITabBarItem 字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:KYTabBarTextNomalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:KYTabBarTextSelectedColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
        button.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.centerButton = button;
}

- (void)buttonPressed:(id)sender
{
    [self showPopMenu];
//    [self setSelectedIndex:2];
//    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
}

//弹出测量菜单  图标均为临时文件
- (void)showPopMenu{
    KYTumblrMenuView *menuView = [[KYTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"心电" andIcon:[UIImage imageNamed:@"post_type_bubble_text.png"] andSelectedBlock:^{
        NSLog(@"心电 selected");
    }];
    [menuView addMenuItemWithTitle:@"环境综测" andIcon:[UIImage imageNamed:@"post_type_bubble_photo.png"] andSelectedBlock:^{
        NSLog(@"环境综测 selected");
    }];
    [menuView addMenuItemWithTitle:@"PM2.5" andIcon:[UIImage imageNamed:@"post_type_bubble_quote.png"] andSelectedBlock:^{
        NSLog(@"PM2.5 selected");
    }];
    [menuView addMenuItemWithTitle:@"有害气体" andIcon:[UIImage imageNamed:@"post_type_bubble_link.png"] andSelectedBlock:^{
        NSLog(@"有害气体 selected");
    }];
    [menuView addMenuItemWithTitle:@"温度" andIcon:[UIImage imageNamed:@"post_type_bubble_chat.png"] andSelectedBlock:^{
        NSLog(@"温度 selected");
    }];
    [menuView addMenuItemWithTitle:@"湿度" andIcon:[UIImage imageNamed:@"post_type_bubble_video.png"] andSelectedBlock:^{
        NSLog(@"湿度 selected");
    }];
    [menuView addMenuItemWithTitle:@"气压" andIcon:[UIImage imageNamed:@"post_type_bubble_link.png"] andSelectedBlock:^{
        NSLog(@"气压 selected");
    }];
    [menuView addMenuItemWithTitle:@"噪声" andIcon:[UIImage imageNamed:@"post_type_bubble_chat.png"] andSelectedBlock:^{
        NSLog(@"噪声 selected");
    }];
    [menuView addMenuItemWithTitle:@"紫外线" andIcon:[UIImage imageNamed:@"post_type_bubble_video.png"] andSelectedBlock:^{
        NSLog(@"紫外线 selected");
    }];
    [menuView addMenuItemWithTitle:@"电磁辐射" andIcon:[UIImage imageNamed:@"post_type_bubble_video.png"] andSelectedBlock:^{
        NSLog(@"电磁辐射 selected");
    }];
    [menuView show];
}

- (void)doHighlight:(UIButton*)b {
    [b setHighlighted:YES];
}

- (void)doNotHighlight:(UIButton*)b {
    [b setHighlighted:NO];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.tabBarController.selectedIndex != 2){
        [self performSelector:@selector(doNotHighlight:) withObject:centerButton afterDelay:0];
    }
}

- (BOOL)tabBarHidden {
    return self.centerButton.hidden && self.tabBar.hidden;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    self.centerButton.hidden = tabBarHidden;
    self.tabBar.hidden = tabBarHidden;
}

@end
