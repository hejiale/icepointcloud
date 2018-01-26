//
//  IPCSearchCustomerViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomerListViewController.h"
#import "IPCCustomerCollectionViewCell.h"
#import "IPCCustomerDetailViewController.h"
#import "IPCSearchCustomerViewController.h"
#import "IPCCustomerListViewModel.h"
#import "IPCEditCustomerView.h"

static NSString * const customerIdentifier = @"CustomerCollectionViewCellIdentifier";

@interface IPCCustomerListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,IPCSearchViewDelegate>
{
    BOOL isCancelRequest;
}
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> * keywordHistory;
@property (nonatomic, strong) IPCCustomerListViewModel    * viewModel;
@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter    *refreshFooter;
@property (strong, nonatomic) IPCEditCustomerView * editCustomerView;

@end

@implementation IPCCustomerListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"客户";
    // Load CollectionView
    [self loadCollectionView];
    // Init ViewModel
    self.viewModel = [[IPCCustomerListViewModel alloc]init];
    // Load Data
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
    //According To NetWorkStatus To Reload Customer List
    if (isCancelRequest && self.viewModel.currentPage == 1) {
        [self loadData];
    }else{
        [self.customerCollectionView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // Clear Refresh Animation
    [self stopRefresh];
    ///remove cover
    if ([self.editCustomerView superview]) {
        [self.editCustomerView removeFromSuperview];
        self.editCustomerView = nil;
    }
}

- (NSMutableArray<NSString *> *)keywordHistory
{
    if (!_keywordHistory) {
        _keywordHistory = [[NSMutableArray alloc]init];
    }
    return _keywordHistory;
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.view.jk_width-2)/3;
    CGFloat itemHeight = (self.view.jk_height-2)/5;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    [_customerCollectionView setCollectionViewLayout:layout];
    _customerCollectionView.emptyAlertImage = @"exception_search";
    _customerCollectionView.emptyAlertTitle = @"未查询到客户信息!";
    _customerCollectionView.mj_header = self.refreshHeader;
    _customerCollectionView.mj_footer = self.refreshFooter;
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
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

- (IPCEditCustomerView *)editCustomerView
{
    if (!_editCustomerView) {
        _editCustomerView = [[IPCEditCustomerView alloc]initWithFrame:self.view.bounds
                                                          UpdateBlock:^(NSString *customerId) {
                                                              [self.refreshHeader beginRefreshing];
                                                          }];
    }
    return _editCustomerView;
}

#pragma mark //UICollectionView Refresh Method
- (void)beginRefresh
{
    //Stop Footer Refresh Method
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
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

#pragma mark //Load Normal Method
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
         isCancelRequest = NO;
         __strong typeof(weakSelf) strongSelf = weakSelf;
         if (strongSelf.viewModel.status == IPCFooterRefresh_HasNoMoreData) {
             [strongSelf.refreshFooter noticeNoDataStatus];
         }else if (strongSelf.viewModel.status == IPCRefreshError){
             if ([error code] == NSURLErrorCancelled) {
                 isCancelRequest = YES;
             }else{
                 [IPCCommonUI showError:@"查询客户失败,请稍后重试!"];
             }
         }
         [weakSelf reload];
     }];
}

#pragma mark //Reload CollectionView
- (void)reload
{
    self.customerCollectionView.isBeginLoad = NO;
    [self.customerCollectionView reloadData];
    
    [self stopRefresh];
}

- (void)stopRefresh{
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

#pragma mark //Clicked Events
- (IBAction)searchCustomerAction:(id)sender{
    IPCSearchCustomerViewController * searchVC = [[IPCSearchCustomerViewController alloc]initWithNibName:@"IPCSearchCustomerViewController" bundle:nil];
    searchVC.searchDelegate = self;
    [searchVC showSearchCustomerViewWithSearchWord:self.viewModel.searchWord];
    [self presentViewController:searchVC animated:YES completion:nil];
}

- (IBAction)insertCustomerAction:(id)sender
{
    [self.view addSubview:self.editCustomerView];
    [self.view bringSubviewToFront:self.editCustomerView];
}


#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.customerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
    
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewModel.customerArray.count && self.viewModel) {
        IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
        
        if (customer) {
            IPCCustomerDetailViewController * detailVC = [[IPCCustomerDetailViewController alloc]initWithNibName:@"IPCCustomerDetailViewController" bundle:nil];
            [detailVC setCustomer:customer];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword{
    self.viewModel.searchWord = keyword;
    [self.refreshHeader beginRefreshing];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
