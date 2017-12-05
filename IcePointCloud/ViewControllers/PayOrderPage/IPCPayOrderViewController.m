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
#import "IPCPayOrderViewMode.h"

@interface IPCPayOrderViewController ()

@property (weak, nonatomic) IBOutlet UIView *leftButtonView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IPCPayOrderCustomerViewController * customerVC;
@property (strong, nonatomic) IPCPayOrderOptometryViewController * optometryVC;
@property (strong, nonatomic) IPCPayOrderOfferOrderViewController * offerOrderVC;
@property (strong, nonatomic) IPCPayOrderPayCashViewController * cashVC;
@property (strong, nonatomic) IPCPayOrderViewMode * viewMode;
@property (strong, nonatomic) NSMutableArray<UIViewController *> * viewControllers;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation IPCPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提交订单";
    _currentPage = NSNotFound;
    //Set UI
    [self.bottomView addTopLine];
    [self.cancelButton addBorder:2 Width:0.5 Color:nil];
    [self.saveButton addBorder:2 Width:0 Color:nil];
    
    self.viewMode = [[IPCPayOrderViewMode alloc]init];
    
    _customerVC = [[IPCPayOrderCustomerViewController alloc]initWithNibName:@"IPCPayOrderCustomerViewController" bundle:nil];
    _optometryVC = [[IPCPayOrderOptometryViewController alloc]initWithNibName:@"IPCPayOrderOptometryViewController" bundle:nil];
    _offerOrderVC = [[IPCPayOrderOfferOrderViewController alloc]initWithNibName:@"IPCPayOrderOfferOrderViewController" bundle:nil];
    _cashVC = [[IPCPayOrderPayCashViewController alloc]initWithNibName:@"IPCPayOrderPayCashViewController" bundle:nil];
    [self.viewControllers addObjectsFromArray:@[_customerVC,_optometryVC,_offerOrderVC,_cashVC]];
    
    [self addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self setCurrentPage:0];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Set Naviagtion Bar
    [self setNavigationBarStatus:YES];
    //获取积分规则
    [self.viewMode queryIntegralRule];
}

- (NSMutableArray<UIViewController *> *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc]init];
    }
    return _viewControllers;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage >= 0 && currentPage <= 3 && currentPage != _currentPage && currentPage != NSNotFound)
    {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIViewController * currentViewController = self.viewControllers[currentPage];
        [self addChildViewController:currentViewController];
        [currentViewController.view setFrame:self.contentView.bounds];
        [self.contentView addSubview:currentViewController.view];
        [currentViewController didMoveToParentViewController:self];
        
        if (currentPage != _currentPage && _currentPage != NSNotFound) {
            UIViewController * preViewController = self.viewControllers[_currentPage];
            [preViewController.view removeFromSuperview];
            [preViewController removeFromParentViewController];
        }
        _currentPage = currentPage;
    }
}

#pragma mark //KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentPage"]) {
        [self reload];
    }
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
        [IPCCommonUI showSuccess:@"挂单成功!"];
        [strongSelf.nextStepButton jk_hideIndicator];
        [strongSelf clearAllPayInfo];
    } PayCash:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [IPCCommonUI showSuccess:@"收银成功!"];
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
    if ([[IPCPayOrderManager sharedManager] isCanPayOrder] && [self.cashVC isEndPayRecord]) {
        [self offerOrder:NO];
    }
}

- (IBAction)nextStepAction:(id)sender
{
    if (![IPCPayOrderManager sharedManager].currentCustomerId) {
        [IPCCommonUI showError:@"请先选择客户信息!"];
    }else{
        NSInteger nextPage = _currentPage + 1;
        [self setCurrentPage:nextPage];
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
    [self setCurrentPage:0];
    [[IPCPayOrderManager sharedManager] resetData];
}


- (IBAction)changePageIndex:(UIButton *)sender
{
    if (![IPCPayOrderManager sharedManager].currentCustomerId) {
        [IPCCommonUI showError:@"请先选择客户信息!"];
    }else{
        [self setCurrentPage:sender.tag];
    }
}

#pragma mark //Reload Methods
- (void)reload
{
    [self.leftButtonView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)obj;
            if (button.tag == _currentPage) {
                [button setSelected:YES];
            }else{
                [button setSelected:NO];
            }
        }
    }];
    
    if (_currentPage == 3) {
        [self.nextStepButton setHidden:YES];
        [self.saveButton setHidden:NO];
    }else{
        [self.nextStepButton setHidden:NO];
        [self.saveButton setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
