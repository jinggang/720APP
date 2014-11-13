//
//  KYLoginController.m
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "KYLoginController.h"

@interface KYLoginController ()

@end

@implementation KYLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]]];
}
- (IBAction)loginBtnClick:(id)sender {
    [self performSegueWithIdentifier:@"loginToHome" sender:self];
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
