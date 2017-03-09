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
#import "IPCSearchViewController.h"
#import "IPCGlassListViewMode.h"

static NSString * const glassListCellIdentifier = @"GlasslistCollectionViewCellIdentifier";

@interface IPCGlassListViewController ()<GlasslistCollectionViewCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic)   IBOutlet UICollectionView               *glassListCollectionView;
@property (strong, nonatomic) IBOutlet UIView                              *backGroudView;
@property (strong, nonatomic) IPCGlassParameterView                  *parameterView;
@property (strong, nonatomic) IPCEditBatchParameterView           *editParameterView;
@property (nonatomic, strong) IPCRefreshAnimationHeader          *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter           *refreshFooter;
@property (strong, nonatomic) IPCGlassListViewMode                   *glassListViewMode;

@end

@implementation IPCGlassListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glassListViewMode =  [[IPCGlassListViewMode alloc]init];
    self.glassListViewMode.isTrying = NO;
    
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
    
    __weak typeof (self) weakSelf = self;
    if ([IPCUIKit rootViewcontroller]) {
        IPCRootMenuViewController * rootVC = (IPCRootMenuViewController *)[IPCUIKit rootViewcontroller];
        [[rootVC rac_signalForSelector:@selector(searchProductAction)] subscribeNext:^(id x) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeCover];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.glassListCollectionView reloadData];
    [[IPCClient sharedClient] cancelAllRequest];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeCover];
}



#pragma mark //Set UI
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

- (void)addBackgroundView{
    if ([self.backGroudView superview])[self removeCover];
    
    [self.backGroudView setFrame:self.view.bounds];
    [self.view addSubview:self.backGroudView];
    [self.view bringSubviewToFront:self.backGroudView];
}


#pragma mark //Refresh Method
- (void)beginReloadTableView{
    self.glassListViewMode.currentPage = 0;
    self.glassListCollectionView.mj_footer.hidden = NO;
    [IPCUIKit show];
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
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.glassListCollectionView reloadData];
            [strongSelf.refreshHeader endRefreshing];
            [strongSelf.refreshFooter endRefreshing];
            [IPCUIKit hiden];
        });
    });
}

- (void)loadMoreTableView{
    self.glassListViewMode.currentPage++;
    [self loadGlassesListData:^{
        [self.glassListCollectionView reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}

#pragma mark //Load Data
- (void)loadGlassesListData:(void(^)())complete
{
    [self.glassListViewMode reloadGlassListDataWithComplete:^(LSRefreshDataStatus status, NSError *error){
        if (status == IPCRefreshError && error) {
            if (error.code != NSURLErrorNotConnectedToInternet) {
                [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
            }
        }else if (status == IPCFooterRefresh_HasNoMoreData){
            self.glassListCollectionView.mj_footer.hidden = YES;
        }
        if (complete) {
            complete();
        }
    }];
}

#pragma mark //NSNotificationCenter Events
- (void)onFilterProducts{
    if ([self.glassListViewMode.glassesView superview]) {
        [self removeCover];
    }else{
        [self addBackgroundView];
        __weak typeof (self) weakSelf = self;
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

- (void)searchProducts:(NSNotification *)notification{
    [self removeCover];
    self.glassListViewMode.searchWord = notification.userInfo[IPCSearchKeyWord];
    [self.refreshHeader beginRefreshing];
}


#pragma mark //Clicked Events
- (IBAction)tapBgAction{
    [self removeCover];
}

- (void)removeCover
{
    __weak typeof (self) weakSelf = self;
    if ([self.backGroudView superview] && self.glassListViewMode.glassesView) {
        [self.glassListViewMode.glassesView closeCompletion:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.glassListViewMode.glassesView removeFromSuperview];strongSelf.glassListViewMode.glassesView = nil;
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
    [self.glassListCollectionView reloadData];
}

- (void)rootRefresh{
    [self.glassListViewMode.filterValue clear];
    self.glassListViewMode.currentType = IPCTopFIlterTypeFrames;
    [self.refreshHeader beginRefreshing];
}
#pragma mark //UICollectionViewDataSoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.glassListViewMode.glassesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCGlasslistCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:glassListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.isTrying = self.glassListViewMode.isTrying;
    
    if ([self.glassListViewMode.glassesList count] && self.glassListViewMode){
        IPCGlasses * glasses = self.glassListViewMode.glassesList[indexPath.row];
        [cell setGlasses:glasses];
    }
    return cell;
}

#pragma mark //UICollectionViewCellDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark //GlassListViewCellDelegate
- (void)addShoppingCartAnimation:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0)
        [self addCartAnimationInCell:cell];
}

- (void)showProductDetail:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        IPCGlassDetailsViewController * detailVC = [[IPCGlassDetailsViewController alloc]initWithNibName:@"IPCGlassDetailsViewController" bundle:nil];
        detailVC.glasses  = self.glassListViewMode.glassesList[indexPath.row];
        [[detailVC rac_signalForSelector:@selector(pushToCartAction:)] subscribeNext:^(id x) {
            [IPCUIKit pushToRootIndex:4];
            [detailVC.navigationController popToRootViewControllerAnimated:NO];
        }];
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
    }
}

- (void)reloadProductList{
    [self.glassListCollectionView reloadData];
}


#pragma mark //NSNotification
- (void)addNotifications{
    [self clearNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFilterProducts) name:IPCHomeFilterProductNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchProducts:) name:IPCHomeSearchProductNotification object:nil];
}

- (void)clearNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCHomeFilterProductNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCHomeSearchProductNotification object:nil];
}

@end
