//
//  GlassDetailsViewController.m
//  IcePointCloud
//
//  Created by mac on 7/23/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGlassDetailsViewController.h"
#import "IPCProductDetailTableViewCell.h"
#import "IPCGlassParameterView.h"
#import "UIView+Badge.h"

static NSString * const infoDetailIdentifier = @"ProductInfoDetailTableViewCellIdentifier";

@interface IPCGlassDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UITableView * detailTableView;
@property (strong, nonatomic) UIWebView * productDetailWebView;
@property (strong, nonatomic) UILabel * headerLabel;
@property (strong, nonatomic) IPCGlassParameterView * parameterView;

@end

@implementation IPCGlassDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"商品详情"];
    [self setRightItem:@"icon_orderBage" Selection:@selector(pushToCartAction:)];
    [self reloadCartBadge];
    
    [self.view addSubview:self.detailTableView];
    [self.view addSubview:self.productDetailWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarStatus:NO];
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //清除网页内容
    [self.productDetailWebView reload];
    [self.productDetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [self.productDetailWebView jk_clearCookies];
    [self.productDetailWebView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
}

#pragma mark //Set UI
- (UITableView *)detailTableView
{
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _detailTableView.dataSource = self;
        _detailTableView.delegate = self;
        _detailTableView.backgroundColor = [UIColor whiteColor];
        
        UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [footView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *footLabel = [[UILabel alloc]initWithFrame:footView.bounds];
        footLabel.text = @"继续拖动，查看图文详情";
        footLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        footLabel.textColor = [UIColor lightGrayColor];
        footLabel.backgroundColor = [UIColor whiteColor];
        footLabel.textAlignment = NSTextAlignmentCenter;
        [footView addSubview:footLabel];
        
        _detailTableView.tableFooterView = footView;
    }
    return _detailTableView;
}

-(UIWebView *)productDetailWebView{
    if (!_productDetailWebView) {
        _productDetailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_productDetailWebView loadHTMLString:self.glasses.detailLinkURl baseURL:nil];
        _productDetailWebView.backgroundColor = [UIColor whiteColor];
        _productDetailWebView.scrollView.delegate = self;
        [_productDetailWebView addSubview:self.headerLabel];
        [_productDetailWebView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _productDetailWebView;
}


- (UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.jk_width, 30)];
        _headerLabel.text = @"上拉，返回详情";
        _headerLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        _headerLabel.textColor = [UIColor lightGrayColor];
        _headerLabel.backgroundColor = [UIColor whiteColor];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.alpha = 0;
    }
    return _headerLabel;
}


#pragma mark //Clicked Events
- (void)successAddCartMethod{
    [IPCCommonUI showSuccess:@"添加商品成功!"];
    [self reloadCartBadge];
}

- (void)goToDetailAnimation
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.productDetailWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.detailTableView.frame = CGRectMake(0, -self.view.frame.size.height , self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

- (void)backToFirstPageAnimation
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.detailTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height);
        self.productDetailWebView.frame = CGRectMake(0, self.detailTableView.contentSize.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.detailTableView scrollToTop];
    } completion:nil];
}

- (void)addToCartAction
{
    if (([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeReadingGlass) && _glasses.isBatch)
    {
        self.parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
            [self reloadCartBadge];
        }];
        self.parameterView.glasses = _glasses;
        [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
        [self.parameterView show];
    }else{
        [[IPCShoppingCart sharedCart] plusGlass:self.glasses];
        [self successAddCartMethod];
    }
}

- (void)pushToCartAction:(id)sender {
    [IPCPayOrderManager sharedManager].isPayOrderStatus = YES;
    [IPCCommonUI pushToRootIndex:4];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)reloadCartBadge{
    [self.navigationItem.rightBarButtonItem.customView createBadgeText:[NSString stringWithFormat:@"%d",[[IPCShoppingCart sharedCart] allGlassesCount]]];
}


- (void)tryGlassesMethod{
    if ([IPCTryMatch instance].matchItems.count == 0) {
        [[IPCTryMatch instance] initMatchItems];
    }
    [[IPCTryMatch instance] currentMatchItem].glass = self.glasses;
    [IPCCommonUI pushToRootIndex:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCProductDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:infoDetailIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCProductDetailTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    cell.glasses = self.glasses;
    __weak typeof(self) weakSelf = self;
    [[cell rac_signalForSelector:@selector(addCartAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addToCartAction];
    }];
    [[cell rac_signalForSelector:@selector(tryGlassesAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf tryGlassesMethod];
    }];
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT;
}


#pragma mark //UIScrollView Delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if([scrollView isKindOfClass:[UITableView class]]){
        CGFloat valueNum = self.detailTableView.contentSize.height - self.view.frame.size.height;
        if ((offsetY - valueNum) > 0){
            [self goToDetailAnimation];
        }
    }else{
        if(offsetY < 0 && -offsetY > 0){
            [self backToFirstPageAnimation];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if(object == self.productDetailWebView.scrollView && [keyPath isEqualToString:@"contentOffset"])
    {
        [self headLabAnimation:[change[@"new"] CGPointValue].y];
    }
}

- (void)headLabAnimation:(CGFloat)offsetY
{
    self.headerLabel.alpha = -offsetY/30;
    self.headerLabel.center = CGPointMake(self.view.frame.size.width/2, -offsetY/2.f);

    if(-offsetY > 30){
        self.headerLabel.text = @"释放，返回详情";
    }else{
        self.headerLabel.text = @"上拉，返回详情";
    }
}

@end
