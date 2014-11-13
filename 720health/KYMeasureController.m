//
//  KYMeasureController.m
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "KYMeasureController.h"
#import "KYTumblrMenuView.h"
@interface KYMeasureController ()

@end

@implementation KYMeasureController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self showPopMenu];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//弹出测量菜单
- (void)showPopMenu{
    KYTumblrMenuView *menuView = [[KYTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"心电" andIcon:[UIImage imageNamed:@"post_type_bubble_text.png"] andSelectedBlock:^{
        NSLog(@"Text selected");
    }];
    [menuView addMenuItemWithTitle:@"环境综测" andIcon:[UIImage imageNamed:@"post_type_bubble_photo.png"] andSelectedBlock:^{
        NSLog(@"Photo selected");
    }];
    [menuView addMenuItemWithTitle:@"PM2.5" andIcon:[UIImage imageNamed:@"post_type_bubble_quote.png"] andSelectedBlock:^{
        NSLog(@"Quote selected");
        
    }];
    [menuView addMenuItemWithTitle:@"有害气体" andIcon:[UIImage imageNamed:@"post_type_bubble_link.png"] andSelectedBlock:^{
        NSLog(@"Link selected");
        
    }];
    [menuView addMenuItemWithTitle:@"温度" andIcon:[UIImage imageNamed:@"post_type_bubble_chat.png"] andSelectedBlock:^{
        NSLog(@"Chat selected");
        
    }];
    [menuView addMenuItemWithTitle:@"湿度" andIcon:[UIImage imageNamed:@"post_type_bubble_video.png"] andSelectedBlock:^{
        NSLog(@"Video selected");
        
    }];
    [menuView addMenuItemWithTitle:@"气压" andIcon:[UIImage imageNamed:@"post_type_bubble_link.png"] andSelectedBlock:^{
        NSLog(@"Link selected");
        
    }];
    [menuView addMenuItemWithTitle:@"噪声" andIcon:[UIImage imageNamed:@"post_type_bubble_chat.png"] andSelectedBlock:^{
        NSLog(@"Chat selected");
        
    }];
    [menuView addMenuItemWithTitle:@"紫外线" andIcon:[UIImage imageNamed:@"post_type_bubble_video.png"] andSelectedBlock:^{
        NSLog(@"Video selected");
        
    }];
    [menuView addMenuItemWithTitle:@"电磁辐射" andIcon:[UIImage imageNamed:@"post_type_bubble_video.png"] andSelectedBlock:^{
        NSLog(@"Video selected");
        
    }];


    [menuView show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
