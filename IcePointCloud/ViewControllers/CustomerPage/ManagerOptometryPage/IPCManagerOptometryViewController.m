//
//  IPCManagerOptometryViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCManagerOptometryViewController.h"
#import "IPCManagerOptometryViewModel.h"
#import "IPCInsertNewOptometryView.h"
#import "IPCManagerOptometryCell.h"

static NSString * const managerIdentifier = @"IPCManagerOptometryCellIdentifier";

@interface IPCManagerOptometryViewController ()<UITableViewDelegate,UITableViewDataSource,IPCManagerOptometryCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *optometryTableView;
@property (strong, nonatomic) IPCInsertNewOptometryView * editOptometryView;
@property (strong, nonatomic) IPCManagerOptometryViewModel * managerViewModel;

@end

@implementation IPCManagerOptometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Set Up NavigationBar
    [self setNavigationTitle:@"验光单"];
    [self setRightItem:@"icon_insert_btn" Selection:@selector(insertNewOptometryAction)];
    //Load TableView
    [self loadTableView];
    //Load Employee Data
    [[IPCCustomerManager sharedManager] queryEmployee];
    //Load Optometry Data
    [self loadOptometryData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.managerViewModel = nil;
    self.view = nil;
    self.editOptometryView = nil;
}

- (void)setCustomerId:(NSString *)customerId
{
    _customerId = customerId;
    
    if (_customerId) {
        self.managerViewModel = [[IPCManagerOptometryViewModel alloc]init];
        self.managerViewModel.customerId = customerId;
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


- (IPCInsertNewOptometryView *)editOptometryView{
    if (!_editOptometryView) {
        __weak typeof(self) weakSelf = self;
        _editOptometryView = [[IPCInsertNewOptometryView alloc]initWithFrame:self.view.bounds CustomerId:self.customerId CompleteBlock:^(IPCOptometryMode * optometry){
            if (optometry) {
                [weakSelf setDefaultOptometryWithOptometryId:optometry.optometryID];
            }
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
        [IPCCommonUI showSuccess:@"设置成功!"];
        [weakSelf performSelector:@selector(loadOptometryData) withObject:nil afterDelay:1.f];
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
        cell.delegate = self;
    }
    IPCOptometryMode * optometry = self.managerViewModel.optometryList[indexPath.row];
    cell.optometryMode = optometry;
    
    if (indexPath.row == 0) {
        [cell.defaultButton setSelected:YES];
    }else{
        [cell.defaultButton setSelected:NO];
    }
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
        [IPCPayOrderCurrentCustomer sharedManager].currentOpometry = optometry;

        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark //IPCManagerOptometryCellDelegate
- (void)setDefaultOptometry:(IPCManagerOptometryCell *)cell
{
    NSIndexPath * indexPath = [self.optometryTableView indexPathForCell:cell];
    IPCOptometryMode * optometry = self.managerViewModel.optometryList[indexPath.row];
    
    [self setDefaultOptometryWithOptometryId:optometry.optometryID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
        self.editOptometryView = nil;
        self.managerViewModel = nil;
        [IPCHttpRequest cancelAllRequest];
    }
}


@end
