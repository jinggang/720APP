//
//  KYTumblrMenuView.m
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "KYTumblrMenuView.h"
#define KYTumblrMenuViewTag 1999
#define KYTumblrMenuViewImageHeight 70
#define KYTumblrMenuViewTitleHeight 20
#define KYTumblrMenuViewVerticalPadding 20
#define KYTumblrMenuViewHorizontalMargin 20
#define KYTumblrMenuViewRriseAnimationID @"KYTumblrMenuViewRriseAnimationID"
#define KYTumblrMenuViewDismissAnimationID @"KYTumblrMenuViewDismissAnimationID"
#define KYTumblrMenuViewAnimationTime 0.36
#define KYTumblrMenuViewAnimationInterval (KYTumblrMenuViewAnimationTime / 5)

@interface KYTumblrMenuItemButton : UIControl
- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(KYTumblrMenuViewSelectedBlock)block;
@property(nonatomic,copy)KYTumblrMenuViewSelectedBlock selectedBlock;
@end

@implementation KYTumblrMenuItemButton
{
    UIImageView *iconView_;
    UILabel *titleLabel_;
}
- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(KYTumblrMenuViewSelectedBlock)block
{
    self = [super init];
    if (self) {
        iconView_ = [UIImageView new];
        iconView_.image = icon;
        titleLabel_ = [UILabel new];
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        titleLabel_.backgroundColor = [UIColor clearColor];
        titleLabel_.textColor = [UIColor brownColor];
        titleLabel_.text = title;
        _selectedBlock = block;
        [self addSubview:iconView_];
        [self addSubview:titleLabel_];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    iconView_.frame = CGRectMake(0, 0, KYTumblrMenuViewImageHeight, KYTumblrMenuViewImageHeight);
    titleLabel_.frame = CGRectMake(0, KYTumblrMenuViewImageHeight, KYTumblrMenuViewImageHeight, KYTumblrMenuViewTitleHeight);
}


@end


@implementation KYTumblrMenuView

{
    UIImageView *backgroundView_;
    NSMutableArray *buttons_;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        ges.delegate = self;
        [self addGestureRecognizer:ges];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        backgroundView_ = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView_.image = [[UIImage imageNamed:@"modal_background.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:6];
        backgroundView_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:backgroundView_];
        buttons_ = [[NSMutableArray alloc] initWithCapacity:6];
        
        
    }
    return self;
}

- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(KYTumblrMenuViewSelectedBlock)block
{
    KYTumblrMenuItemButton *button = [[KYTumblrMenuItemButton alloc] initWithTitle:title andIcon:icon andSelectedBlock:block];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [buttons_ addObject:button];
}

- (CGRect)frameForButtonAtIndex:(NSUInteger)index
{
    NSUInteger columnCount = 3;
    NSUInteger columnIndex =  index % columnCount;
    
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    NSUInteger rowIndex = index / columnCount;
    
    CGFloat itemHeight = (KYTumblrMenuViewImageHeight + KYTumblrMenuViewTitleHeight) * rowCount + (rowCount > 1?(rowCount - 1) * KYTumblrMenuViewHorizontalMargin:0);
    CGFloat offsetY = (self.bounds.size.height - itemHeight) / 2.0;
    CGFloat verticalPadding = (self.bounds.size.width - KYTumblrMenuViewHorizontalMargin * 2 - KYTumblrMenuViewImageHeight * 3) / 2.0;
    
    CGFloat offsetX = KYTumblrMenuViewHorizontalMargin;
    offsetX += (KYTumblrMenuViewImageHeight+ verticalPadding) * columnIndex;
    
    offsetY += (KYTumblrMenuViewImageHeight + KYTumblrMenuViewTitleHeight + KYTumblrMenuViewVerticalPadding) * rowIndex;
    
    
    return CGRectMake(offsetX, offsetY, KYTumblrMenuViewImageHeight, (KYTumblrMenuViewImageHeight+KYTumblrMenuViewTitleHeight));
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSUInteger i = 0; i < buttons_.count; i++) {
        KYTumblrMenuItemButton *button = buttons_[i];
        button.frame = [self frameForButtonAtIndex:i];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[KYTumblrMenuItemButton class]]) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    for (UIView* subview in buttons_) {
        if (CGRectContainsPoint(subview.frame, location)) {
            return NO;
        }
    }
    
    return YES;
}

- (void)dismiss:(id)sender
{
    [self dropAnimation];
    double delayInSeconds = KYTumblrMenuViewAnimationTime  + KYTumblrMenuViewAnimationInterval * (buttons_.count - 1);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeFromSuperview];
    });
}


- (void)buttonTapped:(KYTumblrMenuItemButton*)btn
{
    [self dismiss:nil];
    double delayInSeconds = KYTumblrMenuViewAnimationTime  + KYTumblrMenuViewAnimationInterval * (buttons_.count + 1);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        btn.selectedBlock();
        
    });
}


- (void)riseAnimation
{
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    
    
    for (NSUInteger index = 0; index < buttons_.count; index++) {
        KYTumblrMenuItemButton *button = buttons_[index];
        button.layer.opacity = 0;
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;
        CGPoint fromPosition = CGPointMake(frame.origin.x + KYTumblrMenuViewImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (KYTumblrMenuViewImageHeight + KYTumblrMenuViewTitleHeight) / 2.0);
        
        CGPoint toPosition = CGPointMake(frame.origin.x + KYTumblrMenuViewImageHeight / 2.0,frame.origin.y + (KYTumblrMenuViewImageHeight + KYTumblrMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * KYTumblrMenuViewAnimationInterval;
        if (!columnIndex) {
            delayInSeconds += KYTumblrMenuViewAnimationInterval;
        }
        else if(columnIndex == 2) {
            delayInSeconds += KYTumblrMenuViewAnimationInterval * 2;
        }
        
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = KYTumblrMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:KYTumblrMenuViewRriseAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
        
        
    }
}

- (void)dropAnimation
{
    NSUInteger columnCount = 3;
    for (NSUInteger index = 0; index < buttons_.count; index++) {
        KYTumblrMenuItemButton *button = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;
        
        CGPoint toPosition = CGPointMake(frame.origin.x + KYTumblrMenuViewImageHeight / 2.0,frame.origin.y +  (rowIndex + 2)*200 + (KYTumblrMenuViewImageHeight + KYTumblrMenuViewTitleHeight) / 2.0);
        
        CGPoint fromPosition = CGPointMake(frame.origin.x + KYTumblrMenuViewImageHeight / 2.0,frame.origin.y + (KYTumblrMenuViewImageHeight + KYTumblrMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * KYTumblrMenuViewAnimationInterval;
        if (!columnIndex) {
            delayInSeconds -= KYTumblrMenuViewAnimationInterval;
        }
        else if(columnIndex == 2) {
            delayInSeconds -= KYTumblrMenuViewAnimationInterval * 2;
        }
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5f :1.0f :1.0f];
        positionAnimation.duration = KYTumblrMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:KYTumblrMenuViewDismissAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
        
        
    }
    
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSUInteger columnCount = 3;
    if([anim valueForKey:KYTumblrMenuViewRriseAnimationID]) {
        NSUInteger index = [[anim valueForKey:KYTumblrMenuViewRriseAnimationID] unsignedIntegerValue];
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + KYTumblrMenuViewImageHeight / 2.0,frame.origin.y + (KYTumblrMenuViewImageHeight + KYTumblrMenuViewTitleHeight) / 2.0);
        CGFloat toAlpha = 1.0;
        
        view.layer.position = toPosition;
        view.layer.opacity = toAlpha;
        
    }
    else if([anim valueForKey:KYTumblrMenuViewDismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:KYTumblrMenuViewDismissAnimationID] unsignedIntegerValue];
        NSUInteger rowIndex = index / columnCount;
        
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + KYTumblrMenuViewImageHeight / 2.0,frame.origin.y -  (rowIndex + 2)*200 + (KYTumblrMenuViewImageHeight + KYTumblrMenuViewTitleHeight) / 2.0);
        
        view.layer.position = toPosition;
    }
}


- (void)show
{
    
    UIViewController *appRootViewController;
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    
    
    appRootViewController = window.rootViewController;
    
    
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController.view viewWithTag:KYTumblrMenuViewTag]) {
        [[topViewController.view viewWithTag:KYTumblrMenuViewTag] removeFromSuperview];
    }
    
    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];
    
    [self riseAnimation];
}

@end