//
//  KYHorizontalScrollTabBar.m
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "KYCoverTabBar.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat KYCoverWidth = 100.0;
static const CGFloat KYCoverHeight = 50.0;

//////////
@interface KYCoverItem : NSObject

@property(strong,nonatomic)UIView * view;
@property(assign,nonatomic)NSInteger index;

@end
@implementation KYCoverItem


@end


//////////
@interface KYCoverScrollView : UIScrollView
{
    UIView * _coverContainerView;
    CGFloat _horzMargin;
    CGFloat _vertMargin;
    NSMutableArray * items;
}

@property(assign,nonatomic)KYCoverTabBar * parentView;

-(UIView *)leftMostVisibleCoverView;
-(UIView *)rightMostVisibleCoverView;

-(void)reloadData;
-(void)removeAllCoverViews;
-(void)repositionVisibleCoverViews;

@end

@implementation KYCoverScrollView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _coverContainerView = [[UIView alloc]initWithFrame:self.bounds];
        _coverContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _coverContainerView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_coverContainerView];
        self.backgroundColor = [UIColor greenColor];
        _horzMargin = 0.0;
        _vertMargin = 0.0;
        items = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(self.parentView.numberOfViews > 0)
    {
        CGRect visibleBounds = [self convertRect:[self bounds] toView:_coverContainerView];
        [self tileCoverViewsFromMinX:CGRectGetMinX(visibleBounds) toMaxX:CGRectGetMaxX(visibleBounds)];
        [self adjustCoverViewsTransformWithVisibleBounds:visibleBounds];
    }
}

-(void)reloadData
{
    [self removeAllCoverViews];
    [self resetContentSize];
    self.contentOffset = CGPointMake(0, 0);
}

-(void)removeAllCoverViews
{
    for(KYCoverItem * item in items)
    {
        [item.view removeFromSuperview];
    }
    [items removeAllObjects];
}

-(UIView *)leftMostVisibleCoverView
{
    if(items.count)
    {
        return ((KYCoverItem *)[items objectAtIndex:0]).view;
    }
    else
    {
        return nil;
    }
}

-(UIView *)rightMostVisibleCoverView
{
    return ((KYCoverItem *)[items lastObject]).view;
}

-(void)repositionVisibleCoverViews
{
    CGFloat oldHorzMargin = _horzMargin;
    CGFloat oldVertMargin = _vertMargin;
    [self resetContentSize];
    for(int i=0;i<items.count;++i)
    {
        UIView * view = [[items objectAtIndex:i] view];
        view.center = CGPointMake(view.center.x + _horzMargin - oldHorzMargin, view.center.y + _vertMargin - oldVertMargin);
    }
}

#pragma mark - Private methods
-(void)resetContentSize
{
    _horzMargin = (CGRectGetWidth(self.frame) - self.parentView.itemSize.width)/2.0;
    _vertMargin = (CGRectGetHeight(self.frame) - self.parentView.itemSize.height)/2.0;
    if(self.parentView.numberOfViews > 0)
    {
        self.contentSize = CGSizeMake(_horzMargin * 2.0 +self.parentView.numberOfViews * self.parentView.itemSize.width + (self.parentView.numberOfViews - 1) * self.parentView.itemSpace, self.frame.size.height);
    }
    else
    {
        self.contentSize = self.frame.size;
    }
    _coverContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
}

-(UIView *)insertCoverViewAtIndex:(NSInteger)index frame:(CGRect)frame
{
    UIView * coverView = [self.parentView.dataSource coverTabBar:self.parentView atIndex:index];
    coverView.frame = frame;
    [_coverContainerView addSubview:coverView];
    return coverView;
}

-(KYCoverItem *)addNewConverViewOnRight:(CGFloat)rightEdge index:(NSInteger)index
{
    KYCoverItem * item = nil;
    if(index>=0&& index<self.parentView.numberOfViews)
    {
        CGRect frame = CGRectMake(rightEdge, _vertMargin, 0, 0);
        frame.size = self.parentView.itemSize;
        UIView * coverView = [self insertCoverViewAtIndex:index frame:frame];
        item = [[KYCoverItem alloc]init];
        item.index = index;
        item.view = coverView;
        [items addObject:item];
    }
    return item;
}

-(KYCoverItem *)addNewCoverViewOnLeft:(CGFloat)leftEdge index:(NSInteger)index
{
    KYCoverItem * item = nil;
    if(index>=0&& index < self.parentView.numberOfViews)
    {
        CGRect frame = CGRectMake(leftEdge - self.parentView.itemSize.width, _vertMargin, 0, 0);
        frame.size = self.parentView.itemSize;
        UIView * coverView = [self insertCoverViewAtIndex:index frame:frame];
        item = [[KYCoverItem alloc]init];
        item.index = index;
        item.view = coverView;
        [items insertObject:item atIndex:0];
    }
    return item;
}

-(CGFloat)leftEdgeOfCoverViewAtIndex:(NSInteger)index
{
    return (_horzMargin + (self.parentView.itemSize.width + self.parentView.itemSpace) * index - self.parentView.itemSpace);
}

-(CGFloat)rightEdgeOfCoverViewAtIndex:(NSInteger)index
{
    return (_horzMargin + (self.parentView.itemSize.width + self.parentView.itemSpace) * (index + 1));
}

-(void)tileCoverViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    if(0 == items.count)
    {
        NSInteger index = ceilf((minimumVisibleX - _horzMargin) / (self.parentView.itemSize.width + self.parentView.itemSpace));
        index = MIN(MAX(0, index), self.parentView.numberOfViews - 1);
        CGFloat rightEdge = _horzMargin + (self.parentView.itemSize.width + self.parentView.itemSpace) * index;
        [self addNewConverViewOnRight:rightEdge index:index];
    }
    
    KYCoverItem * lastCoverItem = [items lastObject];
    CGFloat rightEdge = [self rightEdgeOfCoverViewAtIndex:lastCoverItem.index];
    while (rightEdge < maximumVisibleX)
    {
        lastCoverItem = [self addNewConverViewOnRight:rightEdge index:lastCoverItem.index+1];
        if(lastCoverItem)
        {
            rightEdge = [self rightEdgeOfCoverViewAtIndex:lastCoverItem.index];
        }
        else
        {
            break;
        }
    }
    
    KYCoverItem * firstCoverItem = [items objectAtIndex:0];
    CGFloat leftEdge = [self leftEdgeOfCoverViewAtIndex:firstCoverItem.index];
    while (leftEdge > minimumVisibleX)
    {
        firstCoverItem = [self addNewCoverViewOnLeft:leftEdge index:firstCoverItem.index-1];
        if(firstCoverItem)
        {
            leftEdge = [self leftEdgeOfCoverViewAtIndex:firstCoverItem.index];
        }
        else
        {
            break;
        }
    }
    
    firstCoverItem = [items objectAtIndex:0];
    while (firstCoverItem && CGRectGetMaxX(firstCoverItem.view.frame) < minimumVisibleX)
    {
        [firstCoverItem.view removeFromSuperview];
        [items removeObjectAtIndex:0];
        firstCoverItem = [items objectAtIndex:0];
    }
    
    lastCoverItem = [items lastObject];
    while (lastCoverItem && CGRectGetMinX(lastCoverItem.view.frame) > maximumVisibleX)
    {
        [lastCoverItem.view removeFromSuperview];
        [items removeLastObject];
        lastCoverItem = [items lastObject];
    }
}

-(void)adjustCoverViewsTransformWithVisibleBounds:(CGRect)visibleBounds
{
    CGFloat visibleBoundsCenterX = CGRectGetMidX(visibleBounds);
    for(int i = 0;i<items.count;++i)
    {
        UIView * coverView = [[items objectAtIndex:i] view];
        CGFloat distance = coverView.center.x - visibleBoundsCenterX;
        CGFloat distanceThreshold = self.parentView.itemSize.width + self.parentView.itemSpace;
        
        if(distance <= -distanceThreshold)
        {
            coverView.layer.transform = [self transForm3DWithRotation:self.parentView.itemAngle scale:1.0 perspective:(-1.0/500.0)];
            coverView.layer.zPosition = -10000.0;
        }
        else if(distance < 0 && distance > -distanceThreshold)
        {
            CGFloat percentage = fabsf(distance)/distanceThreshold;
            CGFloat scale = 1.0 + (self.parentView.itemScale - 1.0) * (1.0 - percentage);
            coverView.layer.transform = [self transForm3DWithRotation:self.parentView.itemAngle * percentage scale:scale perspective:(-1.0 / 500.0)];
            coverView.layer.zPosition = -10000.0;
        }
        else if(distance == 0)
        {
            coverView.layer.transform = [self transForm3DWithRotation:0 scale:self.parentView.itemScale perspective:(1.0 / 500.0)];
            coverView.layer.zPosition = 10000.0;
        }
        else if(distance > 0 && distance < distanceThreshold)
        {
            CGFloat percentage = fabsf(distance)/distanceThreshold;
            CGFloat scale = 1.0 + (self.parentView.itemScale - 1.0) * (1.0 - percentage);
            coverView.layer.transform = [self transForm3DWithRotation:-self.parentView.itemAngle * percentage scale:scale perspective:(-1.0/500.0)];
            coverView.layer.zPosition = -10000.0;
        }
        else if(distance >= distanceThreshold)
        {
            coverView.layer.transform = [self transForm3DWithRotation:-self.parentView.itemAngle scale:1.0 perspective:(-1.0/500.0)];
            coverView.layer.zPosition = -10000.0;
        }
    }
}

-(CATransform3D)transForm3DWithRotation:(CGFloat)angle
                                  scale:(CGFloat)scale
                            perspective:(CGFloat)perspective
{
    CATransform3D rotateTransform = CATransform3DIdentity;
    rotateTransform.m34 = perspective;
    rotateTransform = CATransform3DRotate(rotateTransform, angle, 0, 1, 0);
    CATransform3D scaleTransform = CATransform3DIdentity;
    scaleTransform = CATransform3DScale(scaleTransform, scale, scale, 1.0);
    return CATransform3DConcat(rotateTransform, scaleTransform);
}

@end

@interface KYCoverTabBar() <UIScrollViewDelegate>
{
    KYCoverScrollView * _scrollView;
    CGPoint _endDraggingVelocity;
}

@end

@implementation KYCoverTabBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _scrollView = [[KYCoverScrollView alloc]initWithFrame:self.bounds];
        _scrollView.parentView = self;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.decelerationRate = 0.98;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        _numberOfViews = 0;
        _itemSize = CGSizeMake(KYCoverWidth, KYCoverHeight);
        _itemSpace = 0;
        _itemAngle = M_PI_4;
        _itemScale = 1.1;
    }
    return  self;
}

-(void)setFrame:(CGRect)frame
{
    if(!CGRectEqualToRect(self.frame, frame))
    {
        [super setFrame:frame];
        [_scrollView repositionVisibleCoverViews];
    }
}

-(void)setItemSize:(CGSize)itemSize
{
    if(!CGSizeEqualToSize(itemSize, _itemSize))
    {
        NSInteger centerIndex = [self nearByIndexOfScrollViewContentOffset:_scrollView.contentOffset];
        _itemSize = itemSize;
        [_scrollView removeAllCoverViews];
        [_scrollView resetContentSize];
        _scrollView.contentOffset = [self offsetWithCenterCoverViewIndex:centerIndex];
        [_scrollView setNeedsLayout];
    }
}

-(void)setItemSpace:(CGFloat)itemSpace
{
    if(_itemSpace != itemSpace)
    {
        NSInteger centerIndex = [self nearByIndexOfScrollViewContentOffset:_scrollView.contentOffset];
        _itemSpace = itemSpace;
        [_scrollView removeAllCoverViews];
        [_scrollView resetContentSize];
        _scrollView.contentOffset = [self offsetWithCenterCoverViewIndex:centerIndex];
        [_scrollView setNeedsLayout];
    }
}

-(void)setItemAngle:(CGFloat)itemAngle
{
    if(_itemAngle != itemAngle)
    {
        _itemAngle = itemAngle;
        [_scrollView setNeedsLayout];
    }
}

-(void)setItemScale:(CGFloat)itemScale
{
    if(_itemScale != itemScale)
    {
        _itemScale = itemScale;
        [_scrollView setNeedsLayout];
    }
}


-(void)reloadData
{
    _numberOfViews = [self.dataSource numberOfViews:self];
    [_scrollView reloadData];
}

-(UIView *)leftMostVisibleCoverView
{
    return [_scrollView leftMostVisibleCoverView];
}

-(UIView *)rightMostVisibleCoverView
{
    return [_scrollView rightMostVisibleCoverView];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _endDraggingVelocity = velocity;
    if(_endDraggingVelocity.x == 0)
    {
        *targetContentOffset = [self nearByOffsetOfScrollViewContentOffset:_scrollView.contentOffset];
    }
    else
    {
        CGFloat startVelocityX = fabsf(_endDraggingVelocity.x);
        CGFloat decelerationRate = 1.0 - _scrollView.decelerationRate;
        
        CGFloat decelerationSeconds = startVelocityX / decelerationRate;
        CGFloat distance = startVelocityX * decelerationSeconds - .5 * decelerationRate * decelerationSeconds * decelerationSeconds;
        
        CGFloat endOffsetX = _endDraggingVelocity.x > 0 ? (_scrollView.contentOffset.x + distance) : (_scrollView.contentOffset.x - distance);
        
        *targetContentOffset = [self nearByOffsetOfScrollViewContentOffset:CGPointMake(endOffsetX, _scrollView.contentOffset.y)];
    }
}

#pragma mark - private methods
-(NSUInteger)nearByIndexOfScrollViewContentOffset:(CGPoint)contentOffset
{
    NSInteger index = nearbyintf(contentOffset.x / (self.itemSize.width + self.itemSpace));
    return MIN(MAX(0,index), self.numberOfViews-1);
}

-(CGPoint)nearByOffsetOfScrollViewContentOffset:(CGPoint)contentOffset
{
    NSInteger index = [self nearByIndexOfScrollViewContentOffset:contentOffset];
    return CGPointMake(index * (self.itemSize.width + self.itemSpace), contentOffset.y);
}

-(CGPoint)offsetWithCenterCoverViewIndex:(NSInteger)index
{
    return CGPointMake(index * (self.itemSize.width + self.itemSpace), _scrollView.contentOffset.y);
    
}




@end
