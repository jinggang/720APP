//
//  KYCalendarController.m
//  KYCalendarView
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "KYCalendarController.h"
#import "HeaderView.h"
#import "FooterView.h"
#import "NSDate+Helper.h"
#import "MainCell.h"
#import "DeatailCell.h"
#import "INOYearTableController.h"
#import "Event.h"

#define KYHeader_TopOffset 64
#define KYHeader_Height 70
#define KYSegmentControlHeight 33

@interface KYCalendarController ()<UITableViewDataSource,UITableViewDelegate>
{
    int dayCount,lastMonthDayCount,startNumber;
    NSDateFormatter *formatter;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,retain) UITableView *table;
@property(nonatomic,retain) UILabel *navDateLabel;//导航上面的年月
@property (nonatomic, strong) INOYearTableController *yearController;
@end

@implementation KYCalendarController

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//test数据
//    NSArray *cellInfoArray = @[@{@"num":@"1",@"progress":@"50"},@{@"num":@"2",@"progress":@"20"},@{@"num":@"3",@"progress":@"78"},@{@"num":@"4",@"progress":@"60"},@{@"num":@"5",@"progress":@"90"},@{@"num":@"6",@"progress":@"40"},@{@"num":@"7",@"progress":@"50"}];
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]];
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDictionary *dic = @{@"Cell": @"MainCell",@"isAttached":@(NO)};
    NSArray * array = @[dic,dic,dic,dic,dic,dic];
    self.dataArray = [[NSMutableArray alloc]init];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    
    //日历顶部 week
    HeaderView *header =[[HeaderView alloc]init];
    header.frame = CGRectMake(0, KYHeader_TopOffset, ScreenWidth, KYHeader_Height);
    header.backgroundColor = [UIColor clearColor];
    [self.view addSubview:header];
    
    //添加日历区域(table)
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, KYHeader_TopOffset+KYHeader_Height, ScreenWidth, ScreenHeight-KYHeader_TopOffset-KYHeader_Height-50)];
    self.table.backgroundColor = [UIColor colorWithWhite:3.0 alpha:0];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.table];
    
    //初始化导航栏
    NSDate *date = [[NSDate alloc] init];
    NSDate *yesterday = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    [self createNavViewWithDate:yesterday];
    
    //创建日历内容
    [self createMonthViewWithDate:yesterday];
}


-(void)createNavViewWithDate:(NSDate *)date
{
    self.selectedDate = date;
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:nextDate];
    NSInteger month= [components month];
    NSInteger year= [components year];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    navView.backgroundColor = [UIColor clearColor];
    //左边菜单按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(20, 20, 20, 20);
    [leftButton setImage:[UIImage imageNamed:@"ic_menu.png"] forState:UIControlStateNormal];
    [navView addSubview:leftButton];
    //中间月份选择
    CGFloat labelWidth = 75;
    CGFloat buttonWidth = 20;
    _navDateLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-labelWidth-buttonWidth)/2, 20, labelWidth, 20)];
    _navDateLabel.text = [NSString stringWithFormat:@"%ld %ld月",(long)year,(long)month];
    _navDateLabel.textColor = [UIColor whiteColor];
    _navDateLabel.adjustsFontSizeToFitWidth = YES;
    _navDateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapDateLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDateUseSystemCalendar:)];
    [_navDateLabel addGestureRecognizer:tapDateLabel];
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(_navDateLabel.frame.origin.x+labelWidth+5, buttonWidth, buttonWidth, buttonWidth);
    [selectButton setImage:[UIImage imageNamed:@"ic_arrow_w.png"] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectDateUseSystemCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_navDateLabel];
    [navView addSubview:selectButton];
    
    [self.view addSubview:navView];
    
}

//调用系统日历 选择年月
-(void)selectDateUseSystemCalendar:(UIButton *)sender
{
    [self managedObjectContext];
    self.yearController = [[INOYearTableController alloc] init];
    [self.view addSubview:self.yearController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeYearController:) name:@"closeYearController" object:nil];
}

-(void)closeYearController:(NSNotification *)not
{
    NSDate *date = [[not userInfo] valueForKey:@"date"];//通过YearTableController选择的年月  该日期是所选月份 上月的最后一天
    self.selectedDate = date;
    [self.yearController.view removeFromSuperview];
    [self createMonthViewWithDate:self.selectedDate];
    [self.table reloadData];
}


#pragma mark UITableViewDatasouces
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorColor:[UIColor clearColor]];
    
    if (indexPath.row == [self.dataArray count]) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FooterCell"];
        FooterView *footerView =[[FooterView alloc]init];
        footerView.frame = CGRectMake(0, 0, ScreenWidth, 45);
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:footerView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"MainCell"])
    {
        static NSString *CellIdentifier = @"MainCell";
        MainCell * cell = [[MainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableArray *dataOfCell = [[NSMutableArray alloc]init];
        for(int i= (int)(indexPath.row*7) ; i < (int)((indexPath.row+1)*7); i++)
        {
            int j = 0;
            NSNumber * isAfter;//在今天之后
            if(i < startNumber){//上一月最后几天
                 j = lastMonthDayCount - startNumber + 1 + i;
                isAfter = [self isAfterOfToday:j andFlag:1];
            }
            if(i >= startNumber && i < startNumber + dayCount){//这一月
                 j = i - startNumber + 1;
                isAfter = [self isAfterOfToday:j andFlag:2];
            }
            if(i >= startNumber + dayCount){//下一月开始几天
                 j = i - dayCount - startNumber + 1;
                isAfter = [self isAfterOfToday:j andFlag:3];
            }
            NSString *dateString = [NSString stringWithFormat:@"%d",j];
            
            //测试数据
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:dateString,@"dateString",isAfter,@"isAfter",@{@"isEnviroment":@"1",@"progress":@"50",@"isHealth":@"1"},@"data",nil];
            
            [dataOfCell addObject:dic];
        }
        cell.cellInfoArr = dataOfCell;
        cell = [cell initStyleWithData:dataOfCell];
        for (UILabel *la in cell.labelArray) {
                UITapGestureRecognizer *tapDate = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDetailWithTag:)];
                [la addGestureRecognizer:tapDate];
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else if([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"DeatailCell"]){
        static NSString *CellIdentifier = @"DeatailCell";
        DeatailCell *cell = [[DeatailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

//根据日期判断是否在今天之后
- (NSNumber*)isAfterOfToday:(int)day andFlag:(int)flag{
    NSString *temp = [_navDateLabel.text substringToIndex:_navDateLabel.text.length-1];
    NSString *year = [temp componentsSeparatedByString:@" "][0];
    NSString *month = [temp componentsSeparatedByString:@" "][1];
    if (month.length == 1) {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    NSDate *tempDate = [formatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@",year,month,@"01"]];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:tempDate];
    [components setMonth:([components month] + 1)];//下月
    NSDate *nextMonth = [cal dateFromComponents:components];
    [components setMonth:([components month] - 2)];//上月
    NSDate *lastMonth = [cal dateFromComponents:components];
    NSString *nextMonthStr = [formatter stringFromDate:nextMonth];
    NSString *lastMonthStr = [formatter stringFromDate:lastMonth];
    switch (flag) {
        case 1:
                year = [lastMonthStr componentsSeparatedByString:@"-"][0];
                month = [lastMonthStr componentsSeparatedByString:@"-"][1];
            break;
        case 2:
            break;
        case 3:
            year = [nextMonthStr componentsSeparatedByString:@"-"][0];
            month = [nextMonthStr componentsSeparatedByString:@"-"][1];
            break;
        default:
            break;
    }
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@-%@-%d",year,month,day]];
    NSDate *today = [[NSDate alloc] init];
    if ([date compare:today] ==NSOrderedDescending) {
        return  [NSNumber numberWithInt:1];
    }
    return [NSNumber numberWithInt:0];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)showDetailWithTag:(UITapGestureRecognizer  *)sender
{
    
    NSLog(@"选中的是这一行的第%ld个元素",(long)sender.view.tag);
    NSLog(@"选中的日期是==%@",((UILabel *)sender.view).text);
    NSIndexPath *path = nil;
    UITableViewCell *cell = (UITableViewCell *)sender.view.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"MainCell"]) {
        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
    }else{
        path = indexPath;
    }
    if ([[self.dataArray[indexPath.row] objectForKey:@"isAttached"] boolValue]) {
        // 关闭附加cell
        NSDictionary * dic = @{@"Cell": @"MainCell",@"isAttached":@(NO)};
        self.dataArray[(path.row-1)] = dic;
        [self.dataArray removeObjectAtIndex:path.row];
        [self.table beginUpdates];
        [self.table deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
        [self.table endUpdates];
        
    }else{
        // 打开附加cell
        NSDictionary * dic = @{@"Cell": @"MainCell",@"isAttached":@(YES)};
        self.dataArray[(path.row-1)] = dic;
        NSDictionary * addDic = @{@"Cell": @"DeatailCell",@"isAttached":@(YES)};
        [self.dataArray insertObject:addDic atIndex:path.row];
        [self.table beginUpdates];
        [self.table insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.table endUpdates];
    }

}

- (void)createMonthViewWithDate:(NSDate*)date
{
    NSDate *select = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:select];
    NSInteger month= [components month];
    NSInteger year= [components year];
    _navDateLabel.text = [NSString stringWithFormat:@"%ld %ld月",(long)year,(long)month];
     dayCount = [NSDate getDayCountOfMonth:(int)month andYear:(int)year];
    if(month == 1)
        lastMonthDayCount = 31;
    else
        lastMonthDayCount = [NSDate getDayCountOfMonth:(int)month - 1 andYear:(int)year];
     startNumber = [NSDate getStartNumber:(int)month andYear:(int)year];
}


#pragma mark - CoreData Helpers

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YearCalendarModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSAssert([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error],
             @"NSPersistentStoreCoordinator error: %@", [error userInfo]);
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
