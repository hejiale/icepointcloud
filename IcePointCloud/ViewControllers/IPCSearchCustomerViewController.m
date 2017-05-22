//
//  IPCSearchCustomerViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSearchCustomerViewController.h"
#import "IPCCustomerCollectionViewCell.h"
#import "IPCInsertCustomerViewController.h"
#import "IPCCustomerDetailViewController.h"
#import "IPCSearchViewController.h"

static NSString * const customerIdentifier = @"CustomerCollectionViewCellIdentifier";

@interface IPCSearchCustomerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,IPCSearchViewControllerDelegate>
{
    NSInteger  currentPage;
    NSString * searchKeyWord;
}
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *insertButton;

@property (nonatomic, strong) NSMutableArray<NSString *> * keywordHistory;
@property (strong, nonatomic) NSMutableArray<IPCCustomerMode *> * customerArray;
@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter     *refreshFooter;


@end

@implementation IPCSearchCustomerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setBackground];
    
    searchKeyWord = @"";
    if ([IPCPayOrderMode sharedManager].isPayOrderStatus) {
        [self setNavigationTitle:@"客户"];
    }
    if ([IPCInsertCustomer instance].isInsertStatus){
        [self.insertButton setHidden:YES];
    }
    [self loadCollectionView];
    [self.refreshHeader beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarStatus:self.isMainStatus];
}

- (NSMutableArray<IPCCustomerMode *> *)customerArray{
    if (!_customerArray) {
        _customerArray = [[NSMutableArray alloc]init];
    }
    return _customerArray;
}

- (void)setIsMainStatus:(BOOL)isMainStatus{
    _isMainStatus = isMainStatus;
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.view.jk_width - 20)/3;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, 146);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.headerReferenceSize = CGSizeMake(self.view.jk_width-10, 5);
    layout.footerReferenceSize = CGSizeMake(self.view.jk_width-10, 5);
    
    [_customerCollectionView setCollectionViewLayout:layout];
    _customerCollectionView.emptyAlertImage = @"exception_search";
    _customerCollectionView.emptyAlertTitle = @"未查询到该客户信息!";
    _customerCollectionView.mj_header = self.refreshHeader;
    _customerCollectionView.mj_footer = self.refreshFooter;
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
}


- (MJRefreshBackStateFooter *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginReloadData)];
    }
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    return _refreshFooter;
}

#pragma mark //Refresh Method
- (void)beginReloadData{
    currentPage = 1;
    [self.customerArray removeAllObjects];
    self.customerCollectionView.mj_footer.hidden = NO;
    [self refreshData];
}

- (void)loadMoreData{
    currentPage++;
    [self refreshData];
}

- (void)refreshData{
    [self queryCustomerInfo:^{
        [self.customerCollectionView reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}


#pragma mark //Request Data
- (void)queryCustomerInfo:(void(^)())complete
{
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    [IPCCustomerRequestManager queryCustomerListWithKeyword:searchKeyWord
                                                       Page:currentPage
                                               SuccessBlock:^(id responseValue)
     {
         IPCCustomerList * customerList = [[IPCCustomerList alloc]initWithResponseValue:responseValue];
         [customerList.list enumerateObjectsUsingBlock:^(IPCCustomerMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [self.customerArray addObject:obj];
         }];
         if (complete) {
             complete();
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
         if (complete) {
             complete();
         }
     }];
}

#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender {
    IPCInsertCustomerViewController * insertCustomerVC = [[IPCInsertCustomerViewController alloc]initWithNibName:@"IPCInsertCustomerViewController" bundle:nil];
    [self.navigationController pushViewController:insertCustomerVC animated:YES];
}

- (IBAction)searchCustomerAction:(id)sender{
    IPCSearchViewController * searchVC = [[IPCSearchViewController alloc]initWithNibName:@"IPCSearchViewController" bundle:nil];
    searchVC.searchDelegate = self;
    [searchVC showSearchCustomerViewWithSearchWord:searchKeyWord];
    [self presentViewController:searchVC animated:YES completion:nil];
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.customerArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
    
    IPCCustomerMode * customer = self.customerArray[indexPath.row];
    cell.currentCustomer = customer;
    
    return cell;
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCCustomerMode * customer = self.customerArray[indexPath.row];
    
    if ([IPCInsertCustomer instance].isInsertStatus) {
        [IPCInsertCustomer instance].introducerId = customer.customerID;
        [IPCInsertCustomer instance].introducerName = customer.customerName;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        IPCCustomerDetailViewController * detailVC = [[IPCCustomerDetailViewController alloc]initWithNibName:@"IPCCustomerDetailViewController" bundle:nil];
        [detailVC setCustomer:customer];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword{
    searchKeyWord = keyword;
    [self.refreshHeader beginRefreshing];
}


@end
