//
//  SLCoverView.m
//  SLCoverFlow
//
//  Created by jiapq on 13-6-19.
//  Copyright (c) 2013年 HNAGroup. All rights reserved.
//

#import "SLCoverView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SLCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 对Z轴进行旋转
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
        rotateAnimation.beginTime = 0.3;
        rotateAnimation.duration = 5; // 持续时间
        rotateAnimation.repeatCount = MAX_INPUT; // 重复次数
        rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
        rotateAnimation.toValue = [NSNumber numberWithFloat:12 * M_PI]; // 终止角度
        
        //    CABasicAnimation *positionAnimation;
        //
        //    positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        //    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_imgView.layer.position.x, _imgView.layer.position.y+50)];
        //    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_imgView.layer.position.x, _imgView.layer.position.y)];
        //    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        //    positionAnimation.duration = 2.0;
        //    positionAnimation.beginTime = 0.3;
        //    positionAnimation.repeatCount = 50;
        //    //    [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:KYTumblrMenuViewRriseAnimationID];
        //    positionAnimation.delegate = self;
        
        [self.layer addAnimation:rotateAnimation forKey:@"transform.rotation.z"];
    }
    return self;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    NSLog(@"SLCoverView layoutSubviews");
    
    _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    
    
    [self addSubview:_imgView];
}


@end
