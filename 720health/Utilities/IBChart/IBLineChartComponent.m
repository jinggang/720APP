//
//  IBLineChartComponent.m
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "IBLineChartComponent.h"
#import <QuartzCore/QuartzCore.h>
@implementation IBLineChartComponent
@synthesize points = _points;

-(id)initWithParentChartView:(IBChartView *)chartView
{
    self = [super initWithParentChartView:chartView];
    if(self)
    {
        _pointColor = [UIColor whiteColor];
        _lineWidth = 1.5f;
        _pointRadius = 2.0f;
        _lineColor = [UIColor whiteColor];
        _cursor = [[UIView alloc]init];
        _cursorColor = [UIColor whiteColor];
        _cursor.backgroundColor = _cursorColor;
        UIView * PView = [[UIView alloc]initWithFrame:CGRectMake(-3 + .5, self.frame.size.height - 3 , 6, 6)];
        PView.layer.masksToBounds = YES;
        [PView.layer setCornerRadius:3];
        PView.backgroundColor = _cursorColor;
        [_cursor addSubview:PView];
        _pointText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 12)];
        _pointText.font = [UIFont systemFontOfSize:12];
        _fillColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:.15];
//        _fillColor = [UIColor redColor];
        _pointTextHidden = YES;
        [self addSubview:_pointText];
        [self addSubview:_cursor];
        self.frame = CGRectMake(self.frame.origin.x - _pointRadius, self.frame.origin.y, self.frame.size.width + _pointRadius*2, self.frame.size.height);
    }
    return self;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation=[[touches anyObject] locationInView:self];
    

    CGFloat X = MIN(self.frame.size.width, MAX(0, touchLocation.x - .5));
    [self setCursorX:X];
}

-(void)setCursorX:(int)X
{
    CGFloat xBili = ( self.frame.size.width - _pointRadius*2)/self.chartView.data.xMax ;
    CGFloat yBili = self.frame.size.height / self.chartView.data.yMax;
    _pointText.hidden = YES;
    for(int i = 0 ;i< _points.count;i++)
    {
        CGPoint point = ((NSValue *)[_points objectAtIndex:i]).CGPointValue;
        CGFloat pX = point.x * xBili + _pointRadius;
        if(X < pX + 4 && X>pX - 4)
        {
            X = pX;
            _pointText.hidden = NO||_pointTextHidden;
            _pointText.text = [NSString stringWithFormat:@"%.1f",point.y];
            _pointText.frame = CGRectMake(X + 2, self.frame.size.height - point.y * yBili -12, _pointText.frame.size.width, _pointText.frame.size.height) ;
            
            if(_delegate&&[(NSObject *)_delegate respondsToSelector:@selector(updataValue:withLineComponent:)])
            {
                [_delegate updataValue:point.y withLineComponent:self];
            }
            _cursor.frame = CGRectMake(X , 0, _cursor.frame.size.width, _cursor.frame.size.height);
            break;
        }
    }
    
}

-(void)setPoints:(NSArray *)points
{
    _points = points;
    _cursor.frame = CGRectMake(0, 0, 1, self.frame.size.height);
    [self setCursorX:0];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    
    UIBezierPath * linePath = [[UIBezierPath alloc]init];
    linePath.lineWidth = _lineWidth;
    linePath.lineCapStyle = kCGLineCapRound;
    linePath.lineJoinStyle = kCGLineJoinRound;
    
    CGFloat xBili = ( self.frame.size.width - _pointRadius*2)/self.chartView.data.xMax ;
    CGFloat yBili = self.frame.size.height / self.chartView.data.yMax;
    for(int i=0;i<_points.count;i++)
    {
        CGPoint point = ((NSValue *)[_points objectAtIndex:i]).CGPointValue;
        if(i==0)
        {
            [linePath moveToPoint:CGPointMake(point.x * xBili + _pointRadius,self.frame.size.height - point.y * yBili)];
        }
        else
        {
            [linePath addLineToPoint:CGPointMake(point.x * xBili+ _pointRadius,self.frame.size.height - point.y * yBili)];
        }
    }
    
    [linePath stroke];

    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    UIBezierPath * fillePath = [[UIBezierPath alloc]init];
    
    
    for(int i=0;i<_points.count;i++)
    {
        CGPoint point = ((NSValue *)[_points objectAtIndex:i]).CGPointValue;
        if(i==0)
        {
            [fillePath moveToPoint:CGPointMake(point.x * xBili + _pointRadius,self.frame.size.height - point.y * yBili)];
        }
        else
        {
            [fillePath addLineToPoint:CGPointMake(point.x * xBili+ _pointRadius,self.frame.size.height - point.y * yBili)];
        }
    }
    
    CGPoint point = ((NSValue *)[_points objectAtIndex:_points.count-1]).CGPointValue;
    [fillePath addLineToPoint:CGPointMake(point.x * xBili+ _pointRadius, self.frame.size.height)];
    CGPoint point2 = ((NSValue *)[_points objectAtIndex:0]).CGPointValue;
    [fillePath addLineToPoint:CGPointMake(point2.x * xBili+ _pointRadius, self.frame.size.height)];
    [fillePath addLineToPoint:CGPointMake(point2.x * xBili+ _pointRadius, point2.y * yBili)];
    
    [fillePath fill];

    
    
    
    CGContextSetStrokeColorWithColor(context, _pointColor.CGColor);
    
    UIBezierPath * pointPath = [[UIBezierPath alloc]init];
    pointPath.lineCapStyle = kCGLineCapRound;
    pointPath.lineJoinStyle = kCGLineJoinRound;
    pointPath.lineWidth = _pointRadius;
    
    
    
    for(int i=0;i<_points.count;i++)
    {
        CGPoint point = ((NSValue *)[_points objectAtIndex:i]).CGPointValue;
        
        [pointPath moveToPoint:CGPointMake(point.x * xBili+ _pointRadius, self.frame.size.height - point.y * yBili)];
        [pointPath addArcWithCenter:CGPointMake(point.x * xBili+ _pointRadius, self.frame.size.height - point.y * yBili) radius:_pointRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    }
    
    [pointPath stroke];
    
    
}



@end
