//
//  KYAnalyzeController.m
//  720health
//
//  Created by rock on 14-10-29.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//  分析页面

#import "KYAnalyzeController.h"
#import "KYAnalyseCell.h"
#import "IBChartView.h"
#import "IBLineChartComponent.h"
#import "IBBulkChartComponent.h"

#define KYSegmentControlTopSpacing 10 //segment向上的间距
#define KYSegmentControlHeight 33 //segment的高度
#define KYVScrollTopSpacing 10  //scroll向上的间距
#define KYVScrollColumnCounts 1  //竖向列数

@interface KYAnalyzeController ()

@property(nonatomic,strong) UISegmentedControl *segment;//顶部日周月切换
@property(nonatomic,strong) UIScrollView *contentScroll;//图表显示区域横向滑动视图
@property(nonatomic,strong) NSMutableArray *tables;//总共的tables

@property(nonatomic,strong) NSMutableArray *typeArray;
@property(nonatomic,strong) NSMutableArray *xTextMArray;
@end

@implementation KYAnalyzeController
{
    IBChartViewDataItem * maiboRiData;
    IBChartViewDataItem * maiboRiData2;
    NSMutableArray * maiboRiPoints;
    NSMutableArray * maiboRiPoints2;
    
    IBChartView * maiboChartView;
    IBLineChartComponent * maiboComponent;
    
    IBChartViewDataItem * shuimianData;
    NSMutableArray * shuimianPoints;
    NSMutableArray * shuimianPoints2;
    IBChartView * shuimianChartView;
    IBBulkChartComponent * shuimianComponent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Analyze", nil);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_back"]
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navbar_back"].CGImage;
    [self.navigationController.navigationBar.layer setMasksToBounds:YES];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.typeArray = [[NSMutableArray alloc]init];
    self.xTextMArray = [[NSMutableArray alloc]init];
    
    [self createData];
    [self setUI];
    [self createContentView];
}

//顶部日周月切换
- (void)setUI{
    self.segment = [[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"Day", nil),NSLocalizedString(@"Week", nil),NSLocalizedString(@"Month", nil)]];
    self.segment.frame = CGRectMake(KYSegmentControlTopSpacing, 64, ScreenWidth-2*KYSegmentControlTopSpacing, KYSegmentControlHeight);
    self.segment.tintColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.segment];
}

//图表显示区域左右滑动视图
- (void)createContentView{
    self.contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.segment.frame.origin.y+KYSegmentControlHeight+KYVScrollTopSpacing, ScreenWidth, ScreenHeight-64-KYSegmentControlTopSpacing-KYSegmentControlHeight-50)];
    self.contentScroll.backgroundColor = [UIColor clearColor];
    self.contentScroll.contentSize = CGSizeMake(ScreenWidth*KYVScrollColumnCounts, self.contentScroll.frame.size.height);
    for (int i = 0; i < KYVScrollColumnCounts; i++) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(i*ScreenWidth, 0, ScreenWidth, self.contentScroll.frame.size.height) style:UITableViewStylePlain];
        table.dataSource = self;
        table.delegate = self;
        table.backgroundColor = [UIColor clearColor];
        [self.contentScroll addSubview:table];
        [self.tables addObject:table];
    }
    [self.navigationController.view addSubview:self.contentScroll];
}

//创建数据  测试数据
- (void)createData{
    NSDictionary* typeDic1=  @{@"typeName":@"睡眠",@"type":@"1"};
    NSDictionary* typeDic2= @{@"typeName":@"运动",@"type":@"2"};
    NSDictionary* typeDic3= @{@"typeName":@"日照量",@"type":@"3"};
    NSDictionary* typeDic4= @{@"typeName":@"脉搏",@"type":@"4"};
    NSDictionary* typeDic5= @{@"typeName":@"体温",@"type":@"5"};
    NSDictionary* typeDic6= @{@"typeName":@"环境舒适度",@"type":@"6"};
    NSDictionary* typeDic7= @{@"typeName":@"环境危害赌",@"type":@"7"};
    
    [self.typeArray addObject:typeDic1];
    [self.typeArray addObject:typeDic2];
    [self.typeArray addObject:typeDic3];
    [self.typeArray addObject:typeDic4];
    [self.typeArray addObject:typeDic5];
    [self.typeArray addObject:typeDic6];
    [self.typeArray addObject:typeDic7];

    
    
    NSArray *xAxesDegreeText1 = @[@"21",@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09"];
    NSArray *xAxesDegreeText2 = @[@"00",@"04",@"06",@"08",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    NSArray *xAxesDegreeText3 = @[@"00",@"04",@"06",@"08",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    NSArray *xAxesDegreeText4 = @[@"00",@"04",@"06",@"08",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    NSArray *xAxesDegreeText5 = @[@"00",@"04",@"06",@"08",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    NSArray *xAxesDegreeText6 = @[@"00",@"04",@"06",@"08",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    NSArray *xAxesDegreeText7 = @[@"00",@"04",@"06",@"08",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    
    [self.xTextMArray addObject:xAxesDegreeText1];
    [self.xTextMArray addObject:xAxesDegreeText2];
    [self.xTextMArray addObject:xAxesDegreeText3];
    [self.xTextMArray addObject:xAxesDegreeText4];
    [self.xTextMArray addObject:xAxesDegreeText5];
    [self.xTextMArray addObject:xAxesDegreeText6];
    [self.xTextMArray addObject:xAxesDegreeText7];
    
    
    [self.tables[0] reloadData];
}


#pragma mark UITableViewDatasouces
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KYAnalyseCell";
    KYAnalyseCell *  cell= [[KYAnalyseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([[self.typeArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"1"]){//睡眠  绘制柱状图
        //睡眠的数据
        shuimianData = [[IBChartViewDataItem alloc]init];
        shuimianData.xAxesDegreeTexts = self.xTextMArray[indexPath.row];
        shuimianData.xMax = 12;
        shuimianData.xInterval = 1;
        shuimianChartView = [[IBChartView alloc]initWithFrame:CGRectMake(0, 0, 300, 150) dataItem:shuimianData];
        shuimianChartView.TLView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuimian"]];//自定义的左上角区域
        shuimianComponent = [[IBBulkChartComponent alloc]initWithParentChartView:shuimianChartView];
        shuimianComponent.delegate = self;
        shuimianPoints = [[NSMutableArray alloc]initWithObjects:nil];
        [shuimianPoints addObject:[NSValue valueWithCGPoint:CGPointMake(2, 5.4)]];
        [shuimianPoints addObject:[NSValue valueWithCGPoint:CGPointMake(5.5, 9)]];
        [shuimianPoints addObject:[NSValue valueWithCGPoint:CGPointMake(9.1, 11)]];
        shuimianComponent.points = shuimianPoints;
        cell.chartView = shuimianChartView;
        cell = [cell initStyleWithChartView:shuimianChartView];
    }else{
        //脉搏的数据
        maiboRiData = [[IBChartViewDataItem alloc]init];
        maiboRiData.cutLineLevels = @[[NSNumber numberWithFloat:20],[NSNumber numberWithFloat:78]];//绘制虚线
        maiboRiData.cutLineColors = @[[UIColor blueColor],[UIColor grayColor]];//虚线颜色
        maiboRiData.xAxesDegreeTexts = self.xTextMArray[indexPath.row];
        maiboRiData.xMax = 24;
        maiboRiData.xInterval = 2;
        
        maiboChartView = [[IBChartView alloc]initWithFrame:CGRectMake(0, 0, 300, 150) dataItem:maiboRiData];
        maiboChartView.TLView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"maibo"]];
        maiboChartView.TRView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"maibozhengchang"]];
        
        maiboComponent = [[IBLineChartComponent alloc]initWithParentChartView:maiboChartView];
        maiboComponent.delegate = self;
        maiboRiPoints = [[NSMutableArray alloc]initWithObjects:nil];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(0, 40)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(2, 30)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(4, 50)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(6, 60)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(8, 65)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(10, 44)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(12, 87)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(14, 77)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(16, 54)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(18, 76)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(20, 56)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(22, 44)]];
        [maiboRiPoints addObject:[NSValue valueWithCGPoint:CGPointMake(24, 66)]];
        maiboComponent.points = maiboRiPoints;
        cell.chartView = maiboChartView;
        cell = [cell initStyleWithChartView:maiboChartView];
    }
    return cell;
}

-(void)updataValue:(CGFloat)value withLineComponent:(IBLineChartComponent *)component
{
//    NSLog(@"当前睡眠状态为  %f",value);
}

-(void)updataValue:(BOOL)value withComponent:(IBBulkChartComponent *)component
{
//    NSLog(@"IBBulkChartComponent%i",value);
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
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
