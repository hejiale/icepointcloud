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

@end

@implementation IPCManagerOptometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Set Up NavigationBar
    [self setNavigationBarStatus:NO];
    [self setNavigationTitle:@"验光单"];
    [self setRightItem:@"icon_insert_btn" Selection:@selector(insertNewOptometryAction)];
    //Load TableView
    [self loadTableView];
    //Load Employee Data
    [[IPCEmployeeeManager sharedManager] queryEmployee];
    //Load Optometry Data
    [self loadOptometryData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //Cancel Request
    [[IPCHttpRequest sharedClient] cancelAllRequest];
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
- (void)loadTableView{
    [self.optometryTableView setTableHeaderView:[[UIView alloc]init]];
    [self.optometryTableView setTableFooterView:[[UIView alloc]init]];
    self.optometryTableView.estimatedSectionFooterHeight = 0;
    self.optometryTableView.estimatedSectionHeaderHeight = 0;
    self.optometryTableView.emptyAlertTitle = @"暂未添加验光单!";
    self.optometryTableView.emptyAlertImage = @"exception_optometry";
}


- (IPCEditOptometryView *)editOptometryView{
    if (!_editOptometryView) {
        __weak typeof(self) weakSelf = self;
        _editOptometryView = [[IPCEditOptometryView alloc]initWithFrame:self.view.bounds
                                                             CustomerID:self.managerViewModel.customerId
                                                               Complete:^(NSString *optometryId) {
                                                                   __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                   [_editOptometryView removeFromSuperview];
                                                                   [strongSelf setDefaultOptometryWithOptometryId:optometryId];
                                                               } Dismiss:^{
                                                                   [_editOptometryView removeFromSuperview];
                                                               }];
    }
    return _editOptometryView;
}

#pragma mark //Request Method
- (void)loadOptometryData
{
    [self.managerViewModel.optometryList removeAllObjects];
    self.managerViewModel.optometryList = nil;
    self.optometryTableView.isBeginLoad = YES;
    [self.optometryTableView reloadData];

    __weak typeof(self) weakSelf = self;
    [self.managerViewModel queryCustomerOptometryList:^() {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.optometryTableView.isBeginLoad = NO;
        [strongSelf.optometryTableView reloadData];
    }];
}

- (void)setDefaultOptometryWithOptometryId:(NSString *)optometryId
{
    [IPCCommonUI showInfo:@"正在设置默认验光单.."];
    
    __weak typeof(self) weakSelf = self;
    [self.managerViewModel setCurrentOptometry:optometryId Complete:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [IPCCommonUI showSuccess:@"设置成功!"];
        [strongSelf performSelector:@selector(loadOptometryData) withObject:nil afterDelay:1.f];
    }];
}

#pragma mark //Clicked Events
- (void)insertNewOptometryAction
{
    if (self.editOptometryView) {
        [self.editOptometryView removeFromSuperview];self.editOptometryView = nil;
    }
    [self.view addSubview:self.editOptometryView];
    [self.view bringSubviewToFront:self.editOptometryView];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.managerViewModel.optometryList.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCManagerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:managerIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCManagerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCOptometryMode * optometry = self.managerViewModel.optometryList[indexPath.row];
    cell.optometryMode = optometry;
    
    if (indexPath.row == 0) {
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
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([IPCPayOrderManager sharedManager].isPayOrderStatus) {
        IPCOptometryMode * optometry = self.managerViewModel.optometryList[indexPath.row];
        [IPCCurrentCustomer sharedManager].currentOpometry = nil;
        [IPCCurrentCustomer sharedManager].currentOpometry = optometry;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
