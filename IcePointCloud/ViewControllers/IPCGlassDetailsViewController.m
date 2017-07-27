//
//  GlassDetailsViewController.m
//  IcePointCloud
//
//  Created by mac on 7/23/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGlassDetailsViewController.h"
#import "IPCProductDetailTableViewCell.h"
#import "IPCProductDetailTopTableViewCell.h"
#import "IPCGlassParameterView.h"
#import "IPCShoppingCart.h"
#import "UIView+Badge.h"

static NSString * const infoDetailIdentifier = @"ProductInfoDetailTableViewCellIdentifier";
static NSString * const topIdentifier           = @"DetailTopTableViewCellIdentifier";
static NSString * const specIdentifier         = @"SpecificationCellIdentifier";
static NSString * const webIdentifier          = @"WebViewCellIdentifier";

@interface IPCGlassDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UIButton *customsizedButton;
@property (strong, nonatomic) UIView * specHostView;
@property (strong, nonatomic) UIWebView * productDetailWebView;
@property (strong, nonatomic) IPCGlassParameterView  *parameterView;

@end

@implementation IPCGlassDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"商品详情"];
    [self setRightItem:@"icon_cart_normal" Selection:@selector(pushToCartAction:)];
    [self.detailTableView setTableFooterView:[[UIView alloc]init]];
    
    [self reloadCartBadge];
    [self buildSpecificationViews];
    [self.productDetailWebView loadHTMLString:self.glasses.detailLinkURl baseURL:nil];
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
}

#pragma mark //Set UI
- (UIView *)specHostView{
    if (!_specHostView) {
        _specHostView = [[UIView alloc]initWithFrame:CGRectMake(30, 0, self.detailTableView.jk_width-50, 0)];
        [_specHostView setBackgroundColor:[UIColor clearColor]];
    }
    return _specHostView;
}

- (void)buildSpecificationViews
{
    __block CGFloat yMargin   = 35;
    __block CGFloat lblWidth  = self.specHostView.jk_width/3;
    
    __block NSArray<NSString *> * keys = [self.glasses displayFields].allKeys;
    NSInteger numOfRows = ceil(keys.count / 3);
    
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth*(idx%3), floor(idx / 3) * yMargin, lblWidth, 30)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        label.text = [NSString stringWithFormat:@"%@: %@", obj, [self.glasses displayFields][obj]];
        [self.specHostView addSubview:label];
    }];
    
    CGRect rect = self.specHostView.frame;
    rect.size.height = yMargin * numOfRows + 35;
    self.specHostView.frame = rect;
    
    [self.detailTableView reloadData];
}

- (UIWebView *)productDetailWebView{
    if (!_productDetailWebView) {
        _productDetailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(25, 0, self.detailTableView.jk_width-50, 0)];
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
    [IPCCustomUI showSuccess:@"添加购物车成功!"];
    [self reloadCartBadge];
}

- (IBAction)addToCartAction:(id)sender {
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
    [IPCCustomUI pushToRootIndex:4];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)onCustomsizedAction:(id)sender {
}

- (void)reloadCartBadge{
    [self.navigationItem.rightBarButtonItem.customView createBadgeText:[NSString stringWithFormat:@"%d",[[IPCShoppingCart sharedCart] allGlassesCount]]];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 || section == 2)
        return 2;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IPCProductDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:infoDetailIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCProductDetailTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        cell.glasses = self.glasses;
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCProductDetailTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCProductDetailTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"基本信息"];
            return cell;
        }else{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:specIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.contentView addSubview:self.specHostView];
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            IPCProductDetailTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCProductDetailTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"图文详情"];
            return cell;
        }else{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:webIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:webIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:self.productDetailWebView];
            }
            return cell;
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 300;
    }else if (indexPath.section == 1 && indexPath.row > 0){
        return self.specHostView.jk_height;
    }else if (indexPath.section == 2 && indexPath.row > 0){
        return self.productDetailWebView.jk_height;
    }
    return 55;
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
