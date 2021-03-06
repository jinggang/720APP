//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import "INOYearTableController.h"
#import "INOYearTableCell.h"
#import "INOYearModel.h"

static NSUInteger const kCellsCount = 20;
static NSUInteger const kHalfCellsCount = kCellsCount >> 1;

@interface INOYearTableController ()

@property (nonatomic, strong) INOYearModel *model;

@property (nonatomic, assign) NSInteger  offset;
@property (nonatomic, assign) NSUInteger integerCellHeight; // is used for fast division

@end

@implementation INOYearTableController

- (id)init {
    self = [super init];
    
    if (self) {
        
        _model = [[INOYearModel alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Year Calendar";
    _integerCellHeight = ceilf([INOYearTableCell cellHeight]);
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:kHalfCellsCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kCellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *yearTableCellId = @"YearTableCellId";
    
    INOYearTableCell *cell = [tableView dequeueReusableCellWithIdentifier:yearTableCellId];
    
    if (!cell) {
        cell = [[INOYearTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yearTableCellId];
        [cell setTag:indexPath.row];
    }
    
    NSDate *yearDate = [_model yearWithOffsetFromCurrentDate:indexPath.row + kHalfCellsCount * (_offset -  1)];
    [cell setupWithYearDate:yearDate];
    
    [_model makeMonthsImagesWithDate:yearDate ofSize:[INOYearTableCell monthViewSize]
                           cancelTag:[cell tag]
                          completion: ^(BOOL success, NSArray *monthsImages) {
                              
                              if (success && [monthsImages count] > 0) {
                                  [cell setupWithMonthsImages:monthsImages];
                              }
                              
                          }];
//    cell.userInteractionEnabled = YES;
    return cell;
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPaht====%ld",(long)indexPath.row);

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [INOYearTableCell cellHeight];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint contentOffset  = scrollView.contentOffset;
    
    if (contentOffset.y <= _integerCellHeight) {
        contentOffset.y = scrollView.contentSize.height / 2 + _integerCellHeight;
        _offset--;
    } else if (contentOffset.y >= scrollView.contentSize.height - (_integerCellHeight << 1)) {
        contentOffset.y = scrollView.contentSize.height / 2 - (_integerCellHeight << 1);
        _offset++;
    }
    
    [scrollView setContentOffset:contentOffset];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [_model proceedLoadingOperations];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_model suspendLoadingOperations];
}

@end
