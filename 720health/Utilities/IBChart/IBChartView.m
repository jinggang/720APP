//
//  IBChartView.m
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "IBChartView.h"
#import <QuartzCore/QuartzCore.h>

@implementation IBChartViewDataItem

-(id)init{
    self = [super init];
    if(self)
    {
        self.xMax = 100.0;
        self.xInterval = 10.0;
        self.yMax = 100.0;
        self.yInterval = 10.0;
        
        self.degreeMarginHorizon = 5.0;
        
        self.borderColor = [[UIColor alloc]initWithWhite:1.0 alpha:.4];
        self.borderWidth = 1.0;
        self.backgroundColor = [[UIColor alloc]initWithRed:117/255.0 green:204/255.0 blue:205/255.0 alpha:1];
        self.dividingLineColor = [[UIColor alloc]initWithRed:192/255.0 green:255/255.0 blue:223/255.0 alpha:1];
        self.fontSize = 14;
        self.fontColor = [UIColor whiteColor];
        
        self.cornerRadius = 7.0;
        
        self.marginTop = 40.0;
        self.marginBottom = 26.0;
        self.marginLeft = 15.0;
        self.marginRight = 15.0;
        
        
        
    }
    return self;
}

@end

@implementation IBChartView
{
    NSMutableArray * texts;
}
-(id)initWithFrame:(CGRect)frame dataItem:(IBChartViewDataItem *)data
{
    self = [super initWithFrame:frame];
    if(self)
    {
        texts = [[NSMutableArray alloc]initWithObjects:nil];
        self.data = data;
        
    }
    return self;
}

-(void)setData:(IBChartViewDataItem *)data
{
    _data = data;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = data.borderColor.CGColor;
    self.layer.cornerRadius = data.cornerRadius;
    self.layer.borderWidth = data.borderWidth;
    self.backgroundColor = data.backgroundColor;
    [self setNeedsDisplay];
}

-(void)setTRView:(UIView *)TRView
{
    if(_TRView)
    {
        [_TRView removeFromSuperview];
    }
    _TRView = TRView;
    _TRView.frame = CGRectMake(self.frame.size.width - TRView.frame.size.width - _data.marginRight , (_data.marginTop - _TRView.frame.size.height)/2, _TRView.frame.size.width, _TRView.frame.size.height);
    [self addSubview:_TRView];
    
}

-(void)setTLView:(UIView *)TLView
{
    if(_TLView)
    {
        [_TLView removeFromSuperview];
    }
    _TLView = TLView;
    _TLView.frame = CGRectMake(_data.marginLeft , (_data.marginTop - _TLView.frame.size.height)/2, _TLView.frame.size.width, _TLView.frame.size.height);
    [self addSubview:_TLView];
}


-(UILabel *)getDegreeTopLabelWithText:(NSString *)text centerPoint:(CGPoint)center andFontSize:(CGFloat)fontSize andSize:(CGSize)size andFontColor:(UIColor *)fontColor
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.text = text;
    label.center = center;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = fontColor;
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    for(int i=0;i<texts.count;i++)
    {
        [((UILabel *)[texts objectAtIndex:i]) removeFromSuperview];
    }
    [texts removeAllObjects];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetStrokeColorWithColor(context, _data.dividingLineColor.CGColor);
    
    UIBezierPath * dividingLineColor = [[UIBezierPath alloc]init];
    dividingLineColor.lineWidth = 1;
    dividingLineColor.lineCapStyle = kCGLineCapRound;
    dividingLineColor.lineJoinStyle = kCGLineJoinRound;
    
    [dividingLineColor moveToPoint:CGPointMake(_data.marginLeft, _data.marginTop)];
    [dividingLineColor addLineToPoint:CGPointMake(self.frame.size.width - _data.marginRight, _data.marginTop)];
    
    [dividingLineColor moveToPoint:CGPointMake(_data.marginLeft, self.frame.size.height - _data.marginBottom)];
    [dividingLineColor addLineToPoint:CGPointMake(self.frame.size.width - _data.marginRight, self.frame.size.height - _data.marginBottom)];
    
    
    [dividingLineColor stroke];
    
    CGFloat xDegreeInterval;
    
    if(_data.xAxesDegreeTexts != nil)
    {
        xDegreeInterval = (self.frame.size.width - _data.marginLeft - _data.marginRight) / (_data.xAxesDegreeTexts.count - 1);
        for(int i = 0;i<_data.xAxesDegreeTexts.count;i++)
        {
            CGSize size = CGSizeMake( xDegreeInterval, _data.fontSize);
            CGPoint center = CGPointMake(xDegreeInterval * i + _data.marginLeft, self.frame.size.height - _data.marginBottom / 2);
            UILabel * label = [self getDegreeTopLabelWithText:[_data.xAxesDegreeTexts objectAtIndex:i] centerPoint:center andFontSize:_data.fontSize andSize:size andFontColor:_data.fontColor];
            [self addSubview:label];
            [texts addObject:label];
        }
    }
    else
    {
        int xDegreeNum = _data.xMax / _data.xInterval;
        xDegreeInterval = (self.frame.size.width - _data.marginLeft - _data.marginRight) / xDegreeNum;

        for(int i=0;i<xDegreeNum + 1;i++)
        {
            CGSize size = CGSizeMake( xDegreeInterval - _data.degreeMarginHorizon, _data.fontSize);
            CGPoint center = CGPointMake(xDegreeInterval * i + _data.marginLeft, self.frame.size.height - _data.marginBottom / 2);
            //NSLog(@"%f---%f",center.x,center.y);
            UILabel * label = [self getDegreeTopLabelWithText:[NSString stringWithFormat:@"%.0f",(i * _data.xInterval)] centerPoint:center andFontSize:_data.fontSize andSize:size andFontColor:_data.fontColor];
            [self addSubview:label];
            [texts addObject:label];
        }
    }
    
    if(_data.cutLineLevels!=nil)
    {

        CGFloat yBili = (self.frame.size.height - _data.marginTop - _data.marginBottom) / _data.yMax;
        for(int i = 0;i<_data.cutLineLevels.count;i++)
        {
            int cX = _data.marginLeft;
            CGContextSetStrokeColorWithColor(context, ((UIColor *)[_data.cutLineColors objectAtIndex:i]).CGColor);
            UIBezierPath * cutLinePath = [[UIBezierPath alloc]init];
            cutLinePath.lineWidth = .5;
            cutLinePath.lineCapStyle = kCGLineCapRound;
            cutLinePath.lineJoinStyle = kCGLineJoinRound;
            while (cX < self.frame.size.width - _data.marginRight) {
                [cutLinePath moveToPoint:CGPointMake(cX, self.frame.size.height - _data.marginBottom - ((NSNumber *)[_data.cutLineLevels objectAtIndex:i]).floatValue* yBili)];
                [cutLinePath addLineToPoint:CGPointMake(cX + 4, self.frame.size.height - _data.marginBottom - ((NSNumber *)[_data.cutLineLevels objectAtIndex:i]).floatValue* yBili)];
                cX+=6;
            }
            [cutLinePath stroke];
        }
    }
    
}







@end
