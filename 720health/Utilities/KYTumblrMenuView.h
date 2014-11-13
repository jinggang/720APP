//
//  KYTumblrMenuView.h
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^KYTumblrMenuViewSelectedBlock)(void);

@interface KYTumblrMenuView : UIView<UIGestureRecognizerDelegate>
- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(KYTumblrMenuViewSelectedBlock)block;
- (void)show;


@end
