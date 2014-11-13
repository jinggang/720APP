//
//  KYHomeController.m
//  720health
//
//  Created by rock on 14-10-28.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "KYHomeController.h"
#import "KYHomeContentCell.h"
#import "KYTabBarController.h"

#define TopRatio 0.7 //上面圆球部分所占比例
#define ButtomRatio 0.3 //下面列表所占比例

@interface KYHomeController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic)  UIScrollView *contentScroll;//底层scroller
@property (strong, nonatomic)  UITableView *tableView;//健康记录table
@end

@implementation KYHomeController
{
    NSMutableArray * circleViews;
    CGFloat ratio;
    NSMutableArray * startPoints;
    NSMutableArray * paths;
    NSMutableArray * durations;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
    startPoints = [[NSMutableArray alloc]init];//动画的初始点
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(480, 100)]];
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(-100,200)]];
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(-100, 250)]];
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(-100, 200)]];
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(-100, 100)]];
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(-100, -100)]];
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(-100, 260)]];
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(480, -130)]];
    [startPoints addObject:[NSValue valueWithCGPoint:CGPointMake(400, 340)]];
    
    paths = [[NSMutableArray alloc]init];//动画的贝塞尔曲线  前两个是中间点坐标 后两个是终点坐标
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(160, 100, 160, 208)]];
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(0,30,258,202  )]];
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(100, 290, 226, 290)]];
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(100, 500, 143, 321)]];
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(-100, 274, 64, 274)]];
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(200, 140, 65, 190)]];
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(200, 260, 256, 342)]];
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(320, 0, 236, 120)]];
    [paths addObject:[NSValue valueWithCGRect:CGRectMake(200, 160, 61, 108)]];
    
    durations = [NSMutableArray arrayWithArray:@[@.5,@.4,@.3,@.4,@.35,@.4,@.25,@.45,@.35]];//动画持续时间
    
    circleViews = [NSMutableArray array];//9个圆的排序
    NSArray * imgNames = @[@"bushu",@"xinfugan",@"maibo_ball",@"tibiaowendu",@"huanjingweihai",@"shuimianzhiliang",@"yinshituijian",@"huanjingShushi",@"rizhaoliang"];
    for(int i=0;i<9;i++)
    {
        UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imgNames objectAtIndex:i]]];
        NSLog(@"%f",img.frame.size.width);
        UIView * circle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, img.frame.size.width, img.frame.size.height)];
        [circle addSubview:img];
        [self.contentScroll addSubview:circle];
        [circleViews addObject:circle];
    }
    
    ratio = self.view.frame.size.width / 320.0;
    
    for(int i = 0;i<circleViews.count;i++)
    {
        UIView * circle = [circleViews objectAtIndex:i];
        [circle setTransform:CGAffineTransformMakeScale(ratio, ratio)];
        circle.layer.cornerRadius = circle.frame.size.width / 2 - 4;
        circle.layer.masksToBounds = YES;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBtnClick:)];
        [circle addGestureRecognizer:tapGesture];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    ((KYTabBarController*)self.tabBarController).tabBarHidden = NO;//显示tabbar和中间测量按钮
    ((KYTabBarController*)self.tabBarController).centerButton.hidden = NO;
    for(int i = 0;i<circleViews.count;i++)
    {
        UIView * circle = [circleViews objectAtIndex:i];
        [circle setHidden:YES];
    }
    [_tableView setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    for(int i = 0;i<circleViews.count;i++)
    {
        UIView * circle = [circleViews objectAtIndex:i];
        
        [circle setHidden:NO];
        circle.transform = CGAffineTransformMakeRotation(0);
        CGPoint startPoint = [((NSValue *)[startPoints objectAtIndex:i]) CGPointValue];
        CGRect path = [((NSValue *)[paths objectAtIndex:i]) CGRectValue];
        
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        if(i == 0)
        {
            pathAnimation.delegate = self;
        }
        pathAnimation.removedOnCompletion = YES;
        pathAnimation.duration = [(NSNumber *)[durations objectAtIndex:i] floatValue];
        CGMutablePathRef curvedPath = CGPathCreateMutable();
        CGPathMoveToPoint(curvedPath, NULL, startPoint.x * ratio, startPoint.y * ratio);
        CGPathAddQuadCurveToPoint(curvedPath, NULL, path.origin.x * ratio, path.origin.y * ratio, path.size.width * ratio, path.size.height * ratio);
        pathAnimation.path = curvedPath;
        CGPathRelease(curvedPath);
        [circle.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
        
        circle.frame = CGRectMake(path.size.width * ratio - circle.frame.size.width / 2, path.size.height * ratio  - circle.frame.size.height / 2, circle.frame.size.width, circle.frame.size.height);
    }
}
//设置UI元素
-(void)setUI
{
   
    self.title = NSLocalizedString(@"Home", nil);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_back"]
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navbar_back"].CGImage;
    [self.navigationController.navigationBar.layer setMasksToBounds:YES];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    //底层滑动视图
    _contentScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _contentScroll.contentSize=CGSizeMake(ScreenWidth,ScreenWidth+1450);
    _contentScroll.bounces = NO;
    _contentScroll.showsVerticalScrollIndicator = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.delegate = self;
    _contentScroll.backgroundColor = [UIColor clearColor];
    
    //健康记录table
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _contentScroll.frame.size.height, self.view.frame.size.width, _contentScroll.contentSize.height-260)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentScroll addSubview:_tableView];
    [self.contentView addSubview:_contentScroll];
}


-(void)onBtnClick:(UITapGestureRecognizer *)tapGesture
{
    for (int i = 0; i<circleViews.count; i++) {
        if([[circleViews objectAtIndex:i] isEqual:tapGesture.view])
        {
            NSLog(@"点击了第%d个按钮",i);
            for(int j = 0; j<circleViews.count;j++)
            {
                UIView * circle = [circleViews objectAtIndex:j];
                // 缩放
                CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                scaleAnimation.duration = 0.15; // 动画持续时间
                scaleAnimation.repeatCount = 1; // 重复次数
                scaleAnimation.autoreverses = YES; // 动画结束时执行逆动画
                scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
                scaleAnimation.toValue = [NSNumber numberWithFloat:0.8]; // 结束时的倍率

                // 对Z轴进行旋转
                CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                circle.layer.anchorPoint = CGPointMake(0.5, 0.5);
                rotateAnimation.beginTime = 0.3;
                rotateAnimation.duration = 5; // 持续时间
                rotateAnimation.repeatCount = MAX_INPUT; // 重复次数
                rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
                rotateAnimation.toValue = [NSNumber numberWithFloat:12 * M_PI]; // 终止角度
                
                //向下坠落
                CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
                moveAnimation.beginTime = 0.3;
                moveAnimation.duration = 2.0; // 持续时间
                moveAnimation.repeatCount = 1; // 重复次数
                moveAnimation.fillMode = kCAFillModeForwards;
                moveAnimation.removedOnCompletion = NO;
                moveAnimation.fromValue = [NSValue valueWithCGPoint:circle.layer.position]; // 起始帧
                moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(circle.layer.position.x, ScreenHeight+MAX_INPUT)]; // 终了帧
                
                CAAnimationGroup *group = [CAAnimationGroup animation];
                group.duration = 5;
                group.repeatCount = 1;
                if (j ==  i) {
                    group.animations = [NSArray arrayWithObjects:scaleAnimation,rotateAnimation,moveAnimation,nil];
                }else{
                    group.animations = [NSArray arrayWithObjects:rotateAnimation,moveAnimation,nil];
                }
                [circle.layer addAnimation:group forKey:@"scale-rotate-layer"];
//                [UIView animateWithDuration:.5 delay:(float)(rand() % 30) /150 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                    circle.frame = CGRectMake(circle.frame.origin.x, circle.frame.origin.y + 500, circle.frame.size.width, circle.frame.size.height);
//                    circle.transform = CGAffineTransformMakeRotation(2*M_PI);
//                } completion:nil];
            }
            [UIView animateWithDuration:.5 animations:^{
                _tableView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width , _tableView.frame.size.height);
            }];
            [self performSelector:@selector(pushDetailPage:) withObject:[NSNumber numberWithInt:i] afterDelay:.5];
            break;
        }
    }
}

-(void)pushDetailPage:(NSNumber *)index
{
    int i = index.intValue;
    ((KYTabBarController*)self.tabBarController).tabBarHidden = YES;//隐藏tabbar和中间测量按钮
    ((KYTabBarController*)self.tabBarController).centerButton.hidden = YES;
    [self performSegueWithIdentifier:@"toEnvComLevel" sender:nil];//跳转到环境舒适度页面
    NSLog(@"开始跳转到第%d个页面",i);
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(anim.duration == .5)
    {
        CGFloat tableViewHeight = _tableView.frame.size.height;
        CGFloat tableOffSet = ScreenHeight * ButtomRatio;//下面部分占屏幕的30%
//        if(self.view.frame.size.height == 480.0)
//        {
//            tableViewHeight = 60;  //Iphone4时 表格的高度 这里貌似有点不协调  你们自己处理下 高度貌似太小
//        }
//        else
//        {
//            tableViewHeight = 150 * ratio;  //非Iphone4时 表格的高度
//        }
        [_tableView setHidden:NO];
        [UIView animateWithDuration:.4 animations:^{
            _tableView.frame = CGRectMake(0, self.view.frame.size.height - tableOffSet , self.view.frame.size.width , tableViewHeight);
        }];
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

}

#pragma mark UITableViewDatasouces
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KYHomeContentCell";
    KYHomeContentCell *cell = (KYHomeContentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KYHomeContentCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelected:NO];
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}



@end
