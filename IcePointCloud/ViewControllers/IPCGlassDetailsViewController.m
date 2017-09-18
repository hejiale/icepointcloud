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
static NSString * const webViewIdentifier = @"UIWebViewCellIdentifier";

@interface IPCGlassDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView * detailTableView;
@property (strong, nonatomic) UIWebView * productDetailWebView;
@property (strong, nonatomic) IPCGlassParameterView * parameterView;

@end

@implementation IPCGlassDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"商品详情"];
    [self setRightItem:@"icon_orderBage" Selection:@selector(pushToCartAction:)];
    [self reloadCartBadge];
    
    [self.detailTableView setTableFooterView:[[UIView alloc]init]];
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
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self.productDetailWebView loadHTMLString:self.glasses.detailLinkURl baseURL:nil];
    }
}

#pragma mark //Set UI
-(UIWebView *)productDetailWebView{
    if (!_productDetailWebView) {
        _productDetailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, 0)];
        [_productDetailWebView setBackgroundColor:[UIColor clearColor]];
        _productDetailWebView.delegate = self;
        _productDetailWebView.scrollView.scrollEnabled = NO;
        _productDetailWebView.scrollView.showsVerticalScrollIndicator = NO;
        _productDetailWebView.scrollView.showsHorizontalScrollIndicator = NO;
        [_productDetailWebView jk_makeTransparentAndRemoveShadow];
    }
    return _productDetailWebView;
}

#pragma mark //Clicked Events
- (void)successAddCartMethod{
    [IPCCommonUI showSuccess:@"添加商品成功!"];
    [self reloadCartBadge];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
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
        [[cell rac_signalForSelector:@selector(showMoreAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:webViewIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:webViewIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.productDetailWebView];
        }
        
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.view.jk_height;
    }
    return self.productDetailWebView.jk_height;
}

#pragma mark //UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"]floatValue];
    CGRect frame = webView.frame;
    frame.size.height = height;
    webView.frame = frame;
    [self.detailTableView reloadData];
}

@end
