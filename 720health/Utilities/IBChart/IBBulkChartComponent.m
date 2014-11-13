//
//  IBBulkChartComponent.m
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "IBBulkChartComponent.h"

@implementation IBBulkChartComponent
@synthesize points = _points;//每个点的意思是 x是起点 y是终点

-(id)initWithParentChartView:(IBChartView *)chartView
{
    self = [super initWithParentChartView:chartView];
    if(self)
    {
        _bulkColor = [UIColor colorWithRed:127/255.0 green:224/255.0 blue:193/255.0 alpha:1];
        _bulkMarginTop = 5;
        _bulkMarginBottom = 5;
        
        _cursor = [[UIView alloc]init];
        _cursorColor = [UIColor grayColor];
        _cursor.backgroundColor = _cursorColor;
        UIView * PView = [[UIView alloc]initWithFrame:CGRectMake(-3 + .5, self.frame.size.height - 3 , 6, 6)];
        PView.layer.masksToBounds = YES;
        [PView.layer setCornerRadius:3];
        PView.backgroundColor = _cursorColor;
        [_cursor addSubview:PView];
        [self addSubview:_cursor];
    }
    return self;
}

-(void)setPoints:(NSArray *)points
{
    _points = points;
    _cursor.frame = CGRectMake(0, 0, 1, self.frame.size.height);
    [self setCursorX:0];
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation=[[touches anyObject] locationInView:self];
    
    
    CGFloat X = MIN(self.frame.size.width, MAX(0, touchLocation.x - .5));
    [self setCursorX:X];
}

-(void)setCursorX:(int)X
{
    _cursor.frame = CGRectMake(X , 0, _cursor.frame.size.width, _cursor.frame.size.height);
    CGFloat xBili = self.frame.size.width /self.chartView.data.xMax ;
    
    BOOL YY = NO;
    
    for(int i=0;i<_points.count;i++)
    {
        CGPoint point = ((NSValue *)[_points objectAtIndex:i]).CGPointValue;
        if(X <point.y * xBili && X>point.x* xBili)
        {
            YY = YES;
            break;
        }
    }
    if(_delegate&&[(NSObject *)_delegate respondsToSelector:@selector(updataValue:withComponent:)])
    {
        [_delegate updataValue:YY withComponent:self];
    }    
}


-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _bulkColor.CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    
    UIBezierPath * bulkPath = [[UIBezierPath alloc]init];
    
    
    CGFloat xBili =  self.frame.size.width /self.chartView.data.xMax ;

    for( int i=0;i<_points.count;i++)
    {
        CGPoint bulk = ((NSValue *)[_points objectAtIndex:i]).CGPointValue;
        [bulkPath moveToPoint: CGPointMake(bulk.x * xBili, _bulkMarginTop)];
        [bulkPath addLineToPoint:CGPointMake(bulk.y * xBili, _bulkMarginTop)];
        [bulkPath addLineToPoint:CGPointMake(bulk.y * xBili, self.frame.size.height - _bulkMarginBottom)];
        [bulkPath addLineToPoint:CGPointMake(bulk.x * xBili, self.frame.size.height - _bulkMarginBottom)];
        
    }
    
    [bulkPath fill];
    
    
    
}





















@end
