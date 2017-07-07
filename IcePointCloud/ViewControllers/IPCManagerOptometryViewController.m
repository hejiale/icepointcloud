//
//  IPCManagerOptometryViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCManagerOptometryViewController.h"
#import "IPCManagerOptometryViewModel.h"
#import "IPCEditOptometryView.h"
#import "IPCManagerOptometryCell.h"

static NSString * const managerIdentifier = @"IPCManagerOptometryCellIdentifier";

@interface IPCManagerOptometryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *optometryTableView;
@property (strong, nonatomic) IPCEditOptometryView * editOptometryView;
@property (strong, nonatomic) IPCManagerOptometryViewModel * managerViewModel;
@property (nonatomic, strong) IPCRefreshAnimationHeader          *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter           *refreshFooter;

@end

@implementation IPCManagerOptometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[IPCEmployeeeManager sharedManager] queryEmployee];
    
    [self setNavigationBarStatus:NO];
    [self setNavigationTitle:@"验光单"];
    [self setRightItem:@"icon_insert_btn" Selection:@selector(insertNewOptometryAction)];
    [self.optometryTableView setTableFooterView:[[UIView alloc]init]];
    self.optometryTableView.mj_header = self.refreshHeader;
    self.optometryTableView.mj_footer = self.refreshFooter;
    [self.refreshHeader beginRefreshing];
}

- (void)setCustomerId:(NSString *)customerId
{
    _customerId = customerId;
    
    if (_customerId) {
        self.managerViewModel = [[IPCManagerOptometryViewModel alloc]init];
        self.managerViewModel.customerId = _customerId;
    }
}

#pragma mark //Set UI
- (IPCEditOptometryView *)editOptometryView{
    if (!_editOptometryView) {
        __weak typeof(self) weakSelf = self;
        _editOptometryView = [[IPCEditOptometryView alloc]initWithFrame:self.view.bounds
                                                             CustomerID:self.managerViewModel.customerId
                                                               Complete:^(NSString *optometryId) {
                                                                   __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                   [_editOptometryView removeFromSuperview];
                                                                   [strongSelf.refreshHeader beginRefreshing];
                                                               } Dismiss:^{
                                                                   [_editOptometryView removeFromSuperview];
                                                               }];
    }
    return _editOptometryView;
}

- (MJRefreshBackStateFooter *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginReloadTableView)];
    }
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTableView)];
    return _refreshFooter;
}

#pragma mark //Request Method
- (void)loadOptometryData{
    __weak typeof(self) weakSelf = self;
    [self.managerViewModel queryCustomerOptometryList:^(BOOL canLoadMore) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.optometryTableView reloadData];
        [strongSelf.refreshHeader endRefreshing];
        [strongSelf.refreshFooter endRefreshing];
        
        if (!canLoadMore) {
            self.optometryTableView.mj_footer.hidden = YES;
        }
    }];
}

- (void)setDefaultOptometryWithOptometryId:(NSString *)optometryId
{
    __weak typeof(self) weakSelf = self;
    [self.managerViewModel setCurrentOptometry:optometryId Complete:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.refreshHeader beginRefreshing];
    }];
}

#pragma mark //Clicked Events
- (void)insertNewOptometryAction
{
    [self.view addSubview:self.editOptometryView];
    [self.view bringSubviewToFront:self.editOptometryView];
}

#pragma mark //Refresh Method
- (void)beginReloadTableView{
    self.managerViewModel.currentPage = 1;
    self.optometryTableView.mj_footer.hidden = NO;
    [self loadOptometryData];
}

- (void)loadMoreTableView{
    self.managerViewModel.currentPage ++;
    [self loadOptometryData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.managerViewModel.optometryList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCManagerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:managerIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCManagerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCOptometryMode * optometry = self.managerViewModel.optometryList[indexPath.section];
    cell.optometryMode = optometry;
    if (indexPath.section == 0) {
        [cell.defaultButton setSelected:YES];
    }else{
        [cell.defaultButton setSelected:NO];
    }
    __weak typeof(self) weakSelf = self;
    [[cell rac_signalForSelector:@selector(setDefaultAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setDefaultOptometryWithOptometryId:optometry.optometryID];
    }];
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 5)];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([IPCPayOrderManager sharedManager].isPayOrderStatus) {
        IPCOptometryMode * optometry = self.managerViewModel.optometryList[indexPath.section];
        [IPCCurrentCustomer sharedManager].currentOpometry = nil;
        [IPCCurrentCustomer sharedManager].currentOpometry = optometry;
        [self popToPayOrderViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
