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

static NSString * const infoDetailIdentifier = @"ProductInfoDetailTableViewCellIdentifier";
static NSString * const topIdentifier  = @"DetailTopTableViewCellIdentifier";
static NSString * const specIdentifier = @"SpecificationCellIdentifier";
static NSString * const webIdentifier  = @"WebViewCellIdentifier";

@interface IPCGlassDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIImageView *cartImageView;
@property (weak, nonatomic) IBOutlet UIButton *customsizedButton;

@property (strong, nonatomic) UIView * specHostView;
@property (strong, nonatomic) UIWebView * productDetailWebView;
@property (strong, nonatomic)  UIView   *cartBageView;
@property (strong, nonatomic)  UILabel  *cartBageLabel;
@property (strong, nonatomic) IPCGlassParameterView  *parameterView;

@end

@implementation IPCGlassDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBackground];
    [self.topBarView addSubview:self.cartBageView];
    [self.cartBageView addSubview:self.cartBageLabel];
    [self.topBarView addBottomLine];
    
    [self.detailTableView setTableFooterView:[[UIView alloc]init]];
    [self reloadCartView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:YES];
    
    if (self.glasses) {
        [self.cartImageView setHidden:NO];
        [self.cartBageView setHidden:NO];
        [self.addCartButton setHidden:NO];
    }else{
        [self.cartImageView setHidden:YES];
        [self.cartBageView setHidden:YES];
        [self.customsizedButton setHidden:NO];
    }
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.productDetailWebView reload];
    [self.productDetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [self.productDetailWebView jk_clearCookies];
} 


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self buildSpecificationViews];
        [self.productDetailWebView loadHTMLString:self.glasses.detailLinkURl baseURL:nil];
    }
}

- (void)setCustomsizedProduct:(IPCCustomsizedProduct *)customsizedProduct{
    _customsizedProduct = customsizedProduct;
    
    if (_customsizedProduct) {
        [self buildSpecificationViews];
        [self.productDetailWebView loadHTMLString:self.glasses.detailLinkURl baseURL:nil];
    }
}

#pragma mark //Set UI
- (UIView *)cartBageView{
    if (!_cartBageView) {
        _cartBageView = [[UIView alloc]initWithFrame:CGRectZero];
        [_cartBageView setBackgroundColor:COLOR_RGB_BLUE];
        _cartBageView.layer.cornerRadius = 6;
        [_cartBageView setHidden:YES];
    }
    return _cartBageView;
}

- (UILabel *)cartBageLabel{
    if (!_cartBageLabel) {
        _cartBageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_cartBageLabel setBackgroundColor:[UIColor clearColor]];
        [_cartBageLabel setTextColor:[UIColor whiteColor]];
        [_cartBageLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        _cartBageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cartBageLabel;
}

- (UIView *)specHostView{
    if (!_specHostView) {
        _specHostView = [[UIView alloc]initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-70, 0)];
        [_specHostView setBackgroundColor:[UIColor clearColor]];
    }
    return _specHostView;
}

- (void)buildSpecificationViews
{
    CGFloat yMargin   = 35;
    CGFloat lblWidth  = self.specHostView.jk_width/3;
    
    NSArray<NSString *> *keys = nil;
    if (self.glasses) {
        keys = [self.glasses displayFields].allKeys;
    }else{
        keys = [self.customsizedProduct displayFields].allKeys;
    }
    NSInteger numOfRows = ceil(keys.count / 3);
    
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth*(idx%3), floor(idx / 3) * yMargin, lblWidth, 30)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        if (self.glasses) {
            label.text = [NSString stringWithFormat:@"%@: %@", obj, [self.glasses displayFields][obj]];
        }else{
            label.text = [NSString stringWithFormat:@"%@: %@", obj, [self.customsizedProduct displayFields][obj]];
        }
        [self.specHostView addSubview:label];
    }];
    
    CGRect rect = self.specHostView.frame;
    rect.size.height = yMargin * numOfRows + 35;
    self.specHostView.frame = rect;
    
    [self.detailTableView reloadData];
}

- (UIWebView *)productDetailWebView{
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
        if (self.glasses) {
            cell.glasses = self.glasses;
        }else{
            cell.customsizedProduct = self.customsizedProduct;
        }
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

#pragma mark //Clicked Events
- (void)successAddCartMethod{
    [IPCCustomUI showSuccess:@"添加购物车成功!"];
    [self reloadCartView];
}

- (IBAction)addToCartAction:(id)sender {
    if ((([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeReadingGlass) && _glasses.isBatch) || ([_glasses filterType] == IPCTopFilterTypeAccessory && _glasses.solutionType))
    {
        if ( ([_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeAccessory) && _glasses.stock == 0) {
            [IPCCustomUI showError:@"暂无库存，请重新选择!"];
        }else{
            self.parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
                [self reloadCartView];
            }];
            self.parameterView.glasses = _glasses;
            [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
            [self.parameterView show];
        }
    }else{
        [[IPCShoppingCart sharedCart] plusGlass:self.glasses];
        [self successAddCartMethod];
    }
}


- (IBAction)onBackBtnTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushToCartAction:(id)sender {
}

- (IBAction)onCustomsizedAction:(id)sender {
}


- (void)reloadCartView{
    if ([[IPCShoppingCart sharedCart] allGlassesCount] > 0) {
        [self.cartBageView setHidden:NO];
        [self.cartBageLabel setText:[[NSNumber numberWithInteger:[[IPCShoppingCart sharedCart] allGlassesCount]]stringValue]];
        
        CGFloat width = [self.cartBageLabel.text jk_widthWithFont:self.cartBageLabel.font constrainedToHeight:self.cartBageView.jk_height];
        
        [self.cartBageView setFrame:CGRectMake(self.topBarView.jk_width- width - 25, 28, width + 10, 12)];
        [self.cartBageLabel setFrame:self.cartBageView.bounds];
    }else{
        [self.cartBageView setHidden:YES];
    }
}

@end
