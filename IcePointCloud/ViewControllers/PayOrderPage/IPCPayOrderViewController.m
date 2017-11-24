//
//  IPCPayOrderViewController.m
//  IcePointCloud
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewController.h"
#import "IPCPayOrderCustomerViewController.h"
#import "IPCPayOrderOptometryViewController.h"
#import "IPCPayOrderOfferOrderViewController.h"
#import "IPCPayOrderPayCashViewController.h"
#import "IPCPayorderScrollPageView.h"
#import "IPCPayOrderViewMode.h"

@interface IPCPayOrderViewController ()<IPCPayorderScrollPageViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IPCPayorderScrollPageView * pageView;
@property (strong, nonatomic) IPCPayOrderCustomerViewController * customerVC;
@property (strong, nonatomic) IPCPayOrderOptometryViewController * optometryVC;
@property (strong, nonatomic) IPCPayOrderOfferOrderViewController * offerOrderVC;
@property (strong, nonatomic) IPCPayOrderPayCashViewController * cashVC;
@property (strong, nonatomic) IPCPayOrderViewMode * viewMode;

@end

@implementation IPCPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提交订单";
    //Set UI
    [self.bottomView addTopLine];
    [self.cancelButton addBorder:2 Width:0.5 Color:nil];
    [self.saveButton addBorder:2 Width:0 Color:nil];
    self.viewMode = [[IPCPayOrderViewMode alloc]init];
    
    _pageView = [[IPCPayorderScrollPageView alloc]initWithFrame:CGRectMake(0, 0, 80, self.contentScrollView.jk_height)];
    [_pageView setPageImages:@[@"icon_unpage_0",@"icon_unpage_1",@"icon_unpage_2",@"icon_unpage_3"]];
    [_pageView setOnPageImages:@[@"icon_page_0",@"icon_page_1",@"icon_page_2",@"icon_page_3"]];
    [_pageView setNumberPages:4];
    [_pageView setDelegate:self];
    [self.view addSubview:_pageView];
    
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.jk_width, _pageView.numberPages*self.contentScrollView.jk_height)];
    
    _customerVC = [[IPCPayOrderCustomerViewController alloc]initWithNibName:@"IPCPayOrderCustomerViewController" bundle:nil];
    _optometryVC = [[IPCPayOrderOptometryViewController alloc]initWithNibName:@"IPCPayOrderOptometryViewController" bundle:nil];
    _offerOrderVC = [[IPCPayOrderOfferOrderViewController alloc]initWithNibName:@"IPCPayOrderOfferOrderViewController" bundle:nil];
    _cashVC = [[IPCPayOrderPayCashViewController alloc]initWithNibName:@"IPCPayOrderPayCashViewController" bundle:nil];
    [self insertScrollSubView:@[_customerVC,_optometryVC,_offerOrderVC,_cashVC]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Set Naviagtion Bar
    [self setNavigationBarStatus:YES];
    //获取积分规则
    [self.viewMode queryIntegralRule];
}

#pragma mark //Set UI
- (void)insertScrollSubView:(NSArray<UIViewController *> *)subViews
{
    __block CGFloat left = self.pageView.jk_right;
    __block CGFloat width = self.contentScrollView.jk_width - self.pageView.jk_right;
    __block CGFloat height = self.contentScrollView.jk_height;
    
    __weak typeof(self) weakSelf = self;
    
    [subViews enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addChildViewController:controller];
        [controller.view setFrame:CGRectMake(left, idx*height, width, height)];
        [strongSelf.contentScrollView addSubview:controller.view];
        [controller didMoveToParentViewController:strongSelf];
    }];
}

#pragma mark //Request Methods
- (void)offerOrder:(BOOL)isPrototy
{
    __weak typeof(self) weakSelf = self;
    if (isPrototy) {
        [self.nextStepButton jk_showIndicator];
    }else{
        [self.saveButton jk_showIndicator];
    }
    
    [self.viewMode saveProtyOrder:isPrototy Prototy:^
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.nextStepButton jk_hideIndicator];
        [strongSelf clearAllPayInfo];
    } PayCash:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf clearAllPayInfo];
        [strongSelf.saveButton jk_hideIndicator];
    } Error:^(IPCPayOrderError errorType) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.nextStepButton jk_hideIndicator];
        [strongSelf.saveButton jk_hideIndicator];
    }];
}

#pragma mark //Clicked Events
///收银
- (IBAction)payCashAction:(id)sender
{
    if ([[IPCPayOrderManager sharedManager] isCanPayOrder]) {
        [self offerOrder:NO];
    }
}

- (IBAction)nextStepAction:(id)sender
{
    if (self.pageView.currentPage == 3) {
        
    }else{
        [self.pageView setCurrentPage:self.pageView.currentPage+1];
        [self reloadBottomStatus];
        [self.contentScrollView setContentOffset:CGPointMake(0, self.pageView.currentPage*self.contentScrollView.jk_height)];
    }
}


- (IBAction)areCancelOrderAction:(id)sender
{
    //挂单
    if ([[IPCShoppingCart sharedCart] allGlassesCount] > 0 ) {
        [self offerOrder:YES];
    }else{
        [IPCCommonUI showError:@"购物列表为空"];
    }
}

- (IBAction)cancelAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [IPCCommonUI showAlert:@"温馨提示" Message:@"您确定要取消该订单并清空购物列表及客户信息吗?" Owner:self Done:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf clearAllPayInfo];
    }];
}

- (void)clearAllPayInfo
{
    [self.pageView setCurrentPage:0];
    [self.contentScrollView setContentOffset:CGPointZero];
    [[IPCPayOrderManager sharedManager] resetData];
    [self.customerVC updateUI];
}

#pragma mark //IPCPayorderScrollPageViewDelegate
- (void)changePageIndex:(NSInteger)index
{
    [self reloadBottomStatus];
    [self.contentScrollView setContentOffset:CGPointMake(0, index*self.contentScrollView.jk_height)];
}

- (void)reloadBottomStatus
{
    if (self.pageView.currentPage == 3) {
        [self.nextStepButton setHidden:YES];
        [self.saveButton setHidden:NO];
    }else{
        [self.nextStepButton setHidden:NO];
        [self.saveButton setHidden:YES];
    }
    
    if (self.pageView.currentPage == 1) {
        [self.optometryVC reload];
    }else if (self.pageView.currentPage == 2){
        [self.offerOrderVC updateUI];
    } else if (self.pageView.currentPage == 3){
        [self.cashVC reload];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
