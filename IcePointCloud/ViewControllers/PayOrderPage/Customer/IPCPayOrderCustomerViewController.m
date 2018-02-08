//
//  IPCPayOrderCustomerViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerViewController.h"
#import "IPCPayOrderCustomInfoView.h"
#import "IPCPayOrderCustomerCollectionViewCell.h"
#import "IPCCustomerListViewModel.h"
#import "IPCEditCustomerView.h"
#import "IPCUpdateCustomerView.h"
#import "IPCUpgradeMemberView.h"
#import "IPCScanCodeViewController.h"

static NSString * const customerIdentifier = @"IPCPayOrderCustomerCollectionViewCellIdentifier";

@interface IPCPayOrderCustomerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *customInfoContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insertWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter    *refreshFooter;
@property (nonatomic, strong) IPCCustomerListViewModel    * viewModel;
@property (nonatomic, strong) IPCPayOrderCustomInfoView * infoView;
@property (nonatomic, strong) IPCEditCustomerView * editCustomerView;
@property (nonatomic, strong) IPCUpdateCustomerView * updateCustomerView;
@property (nonatomic, strong) IPCUpgradeMemberView * upgradeMemberView;
@property (nonatomic, strong) IPCPortraitNavigationViewController * cameraNav;

@end

@implementation IPCPayOrderCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Load CollectionView
    [self loadCollectionView];
    //Init Data
    self.viewModel = [[IPCCustomerListViewModel alloc]init];
    [self loadData];
    //KVO
    [[IPCPayOrderManager sharedManager] ipc_addObserver:self ForKeyPath:@"currentCustomerId"];
    
    if (![IPCAppManager sharedManager].companyCofig.isCheckMember) {
        self.insertWidthConstraint.constant = 200;
        [self.scanButton setHidden:NO];
    }
    ///获取客户类别和门店
    [[IPCCustomerManager sharedManager] queryCustomerType];
    [[IPCCustomerManager sharedManager] queryStore];
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.customerCollectionView.jk_width-10)/3;
    CGFloat itemHeight = (self.customerCollectionView.jk_height-30)/7;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    [_customerCollectionView setCollectionViewLayout:layout];
    _customerCollectionView.emptyAlertImage = @"exception_search";
    _customerCollectionView.emptyAlertTitle = @"未查询到客户信息!";
    _customerCollectionView.mj_header = self.refreshHeader;
    _customerCollectionView.mj_footer = self.refreshFooter;
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCPayOrderCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
}

- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    }
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    return _refreshFooter;
}

- (IPCPayOrderCustomInfoView *)infoView
{
    if (!_infoView) {
        __weak typeof(self) weakSelf = self;
        _infoView = [[IPCPayOrderCustomInfoView alloc]initWithFrame:CGRectMake(0, 0, self.customInfoContentView.jk_width, self.customInfoContentView.jk_height-60)];
        [[_infoView rac_signalForSelector:@selector(editCustomerInfoAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf showUpdateCustomerView];
        }];
        [[_infoView rac_signalForSelector:@selector(upgradeMemberAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf showUpgradeMemberView];
        }];
        [[_infoView rac_signalForSelector:@selector(forcedMemberAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [IPCPayOrderManager sharedManager].isValiateMember = YES;
            [weakSelf reloadCustomerInfo];
        }];
    }
    return _infoView;
}

- (void)loadCustomerInfoView
{
    if (self.infoView) {
        [self.infoView removeFromSuperview];
        self.infoView = nil;
    }
    self.bottomConstraint.constant = 60;
    [self.infoView updateCustomerInfo];
    [self.customInfoContentView addSubview:self.infoView];
    [self.customInfoContentView bringSubviewToFront:self.infoView];
    [self.customerCollectionView reloadData];
}

#pragma mark //Refresh Methods
- (void)beginRefresh
{
    //Stop Footer Refresh Method
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [IPCHttpRequest  cancelAllRequest];
    }
    [self.refreshFooter resetDataStatus];
    [self.viewModel resetData];
    
    [self loadCustomerList];
}

- (void)loadMore
{
    self.viewModel.currentPage++;
    [self loadCustomerList];
}

#pragma mark //Load Data
- (void)loadData
{
    [self.viewModel resetData];
    self.customerCollectionView.isBeginLoad = YES;
    [self loadCustomerList];
    [self.customerCollectionView reloadData];
}

#pragma mark //Request Data
- (void)loadCustomerList
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryCustomerList:^(NSError *error)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         if (strongSelf.viewModel.status == IPCFooterRefresh_HasNoMoreData) {
             [strongSelf.refreshFooter noticeNoDataStatus];
         }else if (strongSelf.viewModel.status == IPCRefreshError){
             if ([error code] != NSURLErrorCancelled) {
                 [IPCCommonUI showError:@"查询客户失败,请稍后重试!"];
             }
         }
         [weakSelf reload];
     }];
}

- (void)queryCustomerDetail
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryCustomerDetail:^{
        [weakSelf reloadCustomerInfo];
    }];
}

- (void)validationMemberRequest:(NSString *)code
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel validationMemberRequest:code Complete:^{
        [weakSelf reloadCustomerInfo];
    }];
}

#pragma mark //Reload CollectionView
- (void)reload
{
    self.customerCollectionView.isBeginLoad = NO;
    [self.customerCollectionView reloadData];
    [self stopRefresh];
}

- (void)stopRefresh
{
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender
{
    [self showEditCustomerView];
}

- (IBAction)validationMemberAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    IPCScanCodeViewController *scanVc = [[IPCScanCodeViewController alloc] initWithFinish:^(NSString *result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.cameraNav dismissViewControllerAnimated:YES completion:nil];
        [weakSelf validationMemberRequest:result];
    }];
    self.cameraNav = [[IPCPortraitNavigationViewController alloc]initWithRootViewController:scanVc];
    [self presentViewController:self.cameraNav  animated:YES completion:nil];
}

- (void)showEditCustomerView
{
    __weak typeof(self) weakSelf = self;
    self.editCustomerView = [[IPCEditCustomerView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                          UpdateBlock:^(NSString *customerId)
                             {
                                 [IPCPayOrderManager sharedManager].currentCustomerId = customerId;
                                 [weakSelf loadData];
                             }];
    [[IPCCommonUI currentView] addSubview:self.editCustomerView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.editCustomerView];
}

- (void)showUpdateCustomerView
{
    __weak typeof(self) weakSelf = self;
    self.updateCustomerView = [[IPCUpdateCustomerView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                           DetailCustomer:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer
                                                              UpdateBlock:^(NSString *customerId)
                               {
                                   [weakSelf queryCustomerDetail];
                                   [weakSelf loadData];
                               }];
    [[IPCCommonUI currentView] addSubview:self.updateCustomerView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.updateCustomerView];
}

- (void)showUpgradeMemberView
{
    __weak typeof(self) weakSelf = self;
    self.upgradeMemberView = [[IPCUpgradeMemberView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                               Customer:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer
                                                            UpdateBlock:^
                              {
                                  [IPCCommonUI showSuccess:@"客户升级会员成功!"];
                                  [IPCPayOrderManager sharedManager].isValiateMember = YES;
                                  [weakSelf performSelector:@selector(queryCustomerDetail) withObject:nil afterDelay:1.f];
                                  [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
                              }];
    [[IPCCommonUI currentView] addSubview:self.upgradeMemberView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.upgradeMemberView];
}

- (void)reloadCustomerInfo
{
    [[IPCPayOrderManager sharedManager] clearPayRecord];
    [[IPCPayOrderManager sharedManager] resetCustomerDiscount];
    [[IPCPayOrderManager sharedManager] calculatePayAmount];
    
    [self loadCustomerInfoView];
}



#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.customerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCPayOrderCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
    
    if (self.viewModel && self.viewModel.customerArray.count) {
        IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
        cell.currentCustomer = customer;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Prereload Data
    if (self.viewModel.status == IPCFooterRefresh_HasMoreData) {
        if (!self.refreshFooter.isRefreshing) {
            if (indexPath.row == self.viewModel.customerArray.count -10) {
                [self.refreshFooter beginRefreshing];
            }
        }
    }
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.customerArray.count) {
        IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
        
        if ([customer.customerID isEqualToString:[IPCPayOrderManager sharedManager].currentCustomerId])return;
        
        if (customer) {
            [IPCPayOrderManager sharedManager].isValiateMember = NO;
            [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
        }
    }
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.viewModel.searchWord = [textField.text jk_trimmingWhitespace];
    [self loadData];
}


#pragma mark //KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentCustomerId"])
    {
        if (![IPCPayOrderManager sharedManager].currentCustomerId) {
            [self.infoView removeFromSuperview];
            [self.customerCollectionView reloadData];
            self.bottomConstraint.constant = 10;
            [IPCPayOrderManager sharedManager].isValiateMember = NO;
        }else{
            [self queryCustomerDetail];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
        self.infoView = nil;
        self.editCustomerView = nil;
        self.upgradeMemberView = nil;
        self.updateCustomerView = nil;
        self.cameraNav = nil;
        self.viewModel = nil;
    }
}


@end
