//
//  ShowDetailSegue.m
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "ShowDetailSegue.h"

@implementation ShowDetailSegue
-(void)perform
{
    UIViewController *current = self.sourceViewController;
    UIViewController *next =self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = current;
    current.navigationController.navigationBarHidden = NO;
    [current.navigationController pushViewController:next animated:YES];
    [current.navigationController.view.layer addAnimation:transition forKey:nil];
}
@end
