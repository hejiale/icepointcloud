//
//  GlassListViewController.m
//  IcePointCloud
//
//  Created by mac on 7/23/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGlassListViewController.h"
#import "IPCGlassDetailsViewController.h"
#import "IPCGlasslistCollectionViewCell.h"
#import "IPCGlassParameterView.h"
#import "IPCEditBatchParameterView.h"
#import "IPCProductViewMode.h"
#import "IPCPayOrderViewController.h"
#import "IPCSearchViewController.h"

static NSString * const glassListCellIdentifier = @"GlasslistCollectionViewCellIdentifier";

@interface IPCGlassListViewController ()<GlasslistCollectionViewCellDelegate,IPCSearchViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic)   IBOutlet UICollectionView               *glassListCollectionView;
@property (strong, nonatomic) IPCGlassParameterView                  *parameterView;
@property (strong, nonatomic) IPCEditBatchParameterView           *editParameterView;
@property (nonatomic, strong) IPCRefreshAnimationHeader          *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter           *refreshFooter;
@property (strong, nonatomic) IPCProductViewMode                   *glassListViewMode;

@end

@implementation IPCGlassListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.glassListViewMode =  [[IPCProductViewMode alloc]init];
    self.glassListViewMode.isTrying = NO;
    
    [self loadCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:YES];
    [self.glassListCollectionView reloadData];
    [[IPCHttpRequest sharedClient] cancelAllRequest];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeCover];
}

#pragma mark //Set UI
- (void)loadCollectionView{
    __block CGFloat width = (self.view.jk_width - 10)/3;
    __block CGFloat height = self.view.jk_height/3;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake(width, height)];
    [layout setMinimumLineSpacing:5];
    [layout setMinimumInteritemSpacing:5];
    
    [self.glassListCollectionView setCollectionViewLayout:layout];
    [self.glassListCollectionView registerNib:[UINib nibWithNibName:@"IPCGlasslistCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:glassListCellIdentifier];
    self.glassListCollectionView.mj_header = self.refreshHeader;
    self.glassListCollectionView.mj_footer = self.refreshFooter;
    self.glassListCollectionView.emptyAlertTitle = @"没有找到符合条件的商品";
    self.glassListCollectionView.emptyAlertImage = @"exception_search";
    [self.refreshHeader beginRefreshing];
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


#pragma mark //Refresh Method
- (void)beginReloadTableView{
    self.glassListViewMode.isBeginLoad = YES;
    
    if (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedLens || self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedContactLens)
    {
        self.glassListViewMode.currentPage = 1;
    }else{
        self.glassListViewMode.currentPage = 0;
    }
    self.glassListCollectionView.mj_footer.hidden = NO;
    
    if (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedContactLens) {
        [self loadCustomsizedContactLens];
    }else if (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedLens){
        [self loadCustomsizedLens];
    }else{
        [self loadNormalProducts];
    }
}

- (void)loadMoreTableView{
    self.glassListViewMode.isBeginLoad = NO;
    self.glassListViewMode.currentPage += 9;
    
    if (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedLens) {
        [self loadCustomsizedLens];
    }else if (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedContactLens){
        [self loadCustomsizedContactLens];
    }else{
        [self loadGlassesListData:^{
            [self reload];
        }];
    }
}

#pragma mark //Load Data
- (void)loadNormalProducts{
    __weak typeof (self) weakSelf = self;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf loadGlassesListData:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.glassListViewMode filterGlassCategoryWithFilterSuccess:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf reload];
    });
}

- (void)loadCustomsizedLens{
    __weak typeof (self) weakSelf = self;
    [self.glassListViewMode getCustomsizedLensWithComplete:^(LSRefreshDataStatus status, NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf reload];
    }];
}

- (void)loadCustomsizedContactLens{
    __weak typeof (self) weakSelf = self;
    [self.glassListViewMode getCustomsizedContactLensWithComplete:^(LSRefreshDataStatus status, NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf reload];
    }];
}


- (void)loadGlassesListData:(void(^)())complete
{
    [self.glassListViewMode reloadGlassListDataWithIsTry:NO IsHot:NO Complete:^(LSRefreshDataStatus status, NSError *error){
        if (status == IPCRefreshError && error) {
            [IPCCustomUI showError:error.domain];
        }else if (status == IPCFooterRefresh_HasNoMoreData){
            self.glassListCollectionView.mj_footer.hidden = YES;
        }
        if (complete) {
            complete();
        }
    }];
}


#pragma mark //Clicked Events
- (void)removeCover
{
    [super removeCover];
    __weak typeof (self) weakSelf = self;
    if ([self.backGroudView superview] && self.glassListViewMode.filterView) {
        [self.glassListViewMode.filterView closeCompletion:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.glassListViewMode.filterView removeFromSuperview];strongSelf.glassListViewMode.filterView = nil;
            [strongSelf.backGroudView removeFromSuperview];
        }];
    }
}

//Add a shopping cart animation
- (void)addCartAnimationInCell:(IPCGlasslistCollectionViewCell *)cell{
    [self.glassListCollectionView reloadData];
    CGPoint startPoint  = [cell convertRect:cell.addCartButton.frame toView:self.view.superview].origin;
    CGPoint endPoint   = CGPointMake(self.view.superview.jk_width-85, -30);
    [self startAnimationWithStartPoint:startPoint EndPoint:endPoint];
}

- (void)reload{
    [super reload];
    [self.glassListCollectionView reloadData];
    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];
}

- (void)showPayOrderView{
    IPCPayOrderViewController * payOrderVC = [[IPCPayOrderViewController alloc]initWithNibName:@"IPCPayOrderViewController" bundle:nil];
    if (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedContactLens) {
        [IPCCustomsizedItem sharedItem].payOrderType = IPCPayOrderTypeCustomsizedContactLens;
    }else if (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedLens){
        [IPCCustomsizedItem sharedItem].payOrderType = IPCPayOrderTypeCustomsizedLens;
    }
    [self.navigationController pushViewController:payOrderVC animated:YES];
}

- (void)onFilterProducts{
    [super onFilterProducts];
    if ([self.glassListViewMode.filterView superview]) {
        [self removeCover];
    }else{
        __weak typeof (self) weakSelf = self;
        [self addBackgroundViewWithAlpha:0.2 InView:self.view Complete:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeCover];
        }];
        [self.glassListViewMode loadFilterCategory:self InView:self.backGroudView ReloadClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeCover];
            [strongSelf.refreshHeader beginRefreshing];
        } ReloadUnClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.refreshHeader beginRefreshing];
        }];
    }
}

- (void)onSearchProducts{
    [super onSearchProducts];
    [self removeCover];
    [self presentSearchViewController];
}

- (void)presentSearchViewController{
    IPCSearchViewController * searchViewMode = [[IPCSearchViewController alloc]initWithNibName:@"IPCSearchViewController" bundle:nil];
    searchViewMode.searchDelegate = self;
    [searchViewMode showSearchProductViewWithSearchWord:self.glassListViewMode.searchWord];
    [self presentViewController:searchViewMode animated:YES completion:nil];
}

#pragma mark //UICollectionViewDataSoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedLens || self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedContactLens) {
        return self.glassListViewMode.customsizedList.count;
    }
    return self.glassListViewMode.glassesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCGlasslistCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:glassListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;

    if (self.glassListViewMode.customsizedList.count && (self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedLens || self.glassListViewMode.currentType == IPCTopFilterTypeCustomsizedContactLens))
    {
        IPCCustomsizedProduct * product = self.glassListViewMode.customsizedList[indexPath.row];
        [cell setCustomsizedProduct:product];
    }else{
        if ([self.glassListViewMode.glassesList count] && self.glassListViewMode){
            cell.isTrying = self.glassListViewMode.isTrying;
            IPCGlasses * glasses = self.glassListViewMode.glassesList[indexPath.row];
            [cell setGlasses:glasses];
        }
    }
    return cell;
}

#pragma mark //GlassListViewCellDelegate
- (void)addShoppingCartAnimation:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0)
        [self addCartAnimationInCell:cell];
}

- (void)showProductDetail:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode currentType] == IPCTopFilterTypeCard)return;
    
    if ([self.glassListViewMode.glassesList count] > 0 || [self.glassListViewMode.customsizedList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
    
        IPCGlassDetailsViewController * detailVC = [[IPCGlassDetailsViewController alloc]initWithNibName:@"IPCGlassDetailsViewController" bundle:nil];
        if ([self.glassListViewMode currentType] == IPCTopFilterTypeCustomsizedContactLens || [self.glassListViewMode currentType] == IPCTopFilterTypeCustomsizedLens) {
            IPCCustomsizedProduct * product = self.glassListViewMode.customsizedList[indexPath.row];
            detailVC.customsizedProduct = product;
        }else{
            IPCGlasses * glasses = self.glassListViewMode.glassesList[indexPath.row];
            detailVC.glasses  = glasses;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)chooseParameter:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        self.parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
            [self.glassListCollectionView reloadData];
        }];
        self.parameterView.glasses = self.glassListViewMode.glassesList[indexPath.row];
        [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
        [self.parameterView show];
    }
}

- (void)editBatchParameter:(IPCGlasslistCollectionViewCell *)cell{
    __weak typeof (self) weakSelf = self;
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        self.editParameterView = [[IPCEditBatchParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Glasses:self.glassListViewMode.glassesList[indexPath.row] Dismiss:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.editParameterView removeFromSuperview];strongSelf.editParameterView = nil;
            [strongSelf.glassListCollectionView reloadData];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.editParameterView];
        [self.editParameterView show];
    }
}

- (void)reloadProductList{
    [self reload];
}

- (void)buyValueCard:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        __block NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        IPCPayOrderViewController * payOrderVC = [[IPCPayOrderViewController alloc]initWithNibName:@"IPCPayOrderViewController" bundle:nil];
        [self.navigationController pushViewController:payOrderVC animated:YES];
    }
}

- (void)customsized:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.customsizedList count] > 0) {
        [self showPayOrderView];
    }
}


#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword
{
    self.glassListViewMode.searchWord = keyword;
    [self.refreshHeader beginRefreshing];
}

@end
