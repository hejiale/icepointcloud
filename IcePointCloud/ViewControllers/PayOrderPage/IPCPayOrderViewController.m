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

@interface IPCPayOrderViewController (){
    pthread_mutex_t _lock;
}

@property (weak, nonatomic) IBOutlet UIView *leftButtonView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *areCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areCancelButtonWidth;
@property (strong, nonatomic) IPCPayOrderCustomerViewController * customerVC;
@property (strong, nonatomic) IPCPayOrderOptometryViewController * optometryVC;
@property (strong, nonatomic) IPCPayOrderOfferOrderViewController * offerOrderVC;
@property (strong, nonatomic) IPCPayOrderPayCashViewController * cashVC;
@property (strong, nonatomic) IPCPayOrderViewMode * viewMode;
@property (strong, nonatomic) NSMutableArray<UIViewController *> * viewControllers;
@property (assign, nonatomic) NSUInteger currentPage;

@end

@implementation IPCPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提交订单";
    _currentPage = NSNotFound;
    //Set UI
    [self.cancelButton addBorder:0 Width:1 Color:nil];
    [self.areCancelButton addBorder:0 Width:1 Color:nil];
    [self.bottomView addTopLine];
    //Init Data
    self.viewMode = [[IPCPayOrderViewMode alloc]init];
    //Add Child ViewController
    _customerVC = [[IPCPayOrderCustomerViewController alloc]initWithNibName:@"IPCPayOrderCustomerViewController" bundle:nil];
    _optometryVC = [[IPCPayOrderOptometryViewController alloc]initWithNibName:@"IPCPayOrderOptometryViewController" bundle:nil];
    _offerOrderVC = [[IPCPayOrderOfferOrderViewController alloc]initWithNibName:@"IPCPayOrderOfferOrderViewController" bundle:nil];
    _cashVC = [[IPCPayOrderPayCashViewController alloc]initWithNibName:@"IPCPayOrderPayCashViewController" bundle:nil];
    [self.viewControllers addObjectsFromArray:@[_customerVC,_optometryVC,_offerOrderVC,_cashVC]];
    //Set Current Page
    [self setCurrentPage:0];
    //Query PayType
    [[IPCPayOrderManager sharedManager] queryPayType];
    //获取积分规则
    [self.viewMode queryIntegralRule];
    
    pthread_mutex_init(&_lock, NULL);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Set Naviagtion Bar
    [self setNavigationBarStatus:YES];
    
    [[IPCPayOrderManager sharedManager] calculatePayAmount];
}


- (NSMutableArray<UIViewController *> *)viewControllers
{
    if (!_viewControllers)
        _viewControllers = [[NSMutableArray alloc]init];
    return _viewControllers;
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    if (currentPage >= 0 && currentPage <= 3 && currentPage != _currentPage && currentPage != NSNotFound){
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
        [self reload];
    }
}

#pragma mark //Request Methods
- (void)offerOrder:(NSString *)currentStatus EndStatus:(NSString *)endStatus Complete:(void(^)())complete
{
    pthread_mutex_lock(&_lock);
    
    [IPCCommonUI show];
    
    __weak typeof(self) weakSelf = self;
    [self.viewMode payOrderWithCurrentStatus:currentStatus EndStatus:endStatus Complete:^(NSError * error){
        if (!error) {
            [weakSelf clearAllPayInfo];
            
            if (complete) {
                complete();
            }
        }else{
            [IPCCommonUI showError:error.domain];
        }
        pthread_mutex_unlock(&_lock);
    }];
}


#pragma mark //Clicked Events
///收银
- (IBAction)payCashAction:(id)sender
{
    if ([[IPCPayOrderManager sharedManager] isCanPayOrder]) {
        [IPCPayOrderManager sharedManager].isPayCash = YES;
        
        [self offerOrder:@"NULL" EndStatus:@"AUDITED" Complete:^{
            [IPCCommonUI showSuccess:@"订单收银成功！"];
        }];
    }
}

- (IBAction)nextStepAction:(id)sender
{
    NSUInteger nextPage = _currentPage + 1;
    if (nextPage == 3 && [[IPCPayOrderManager sharedManager] extraDiscount]) {
        if ([[IPCPayOrderManager sharedManager] currentCustomer]) {
            [self offerOrderAction];
        }else{
            [IPCCommonUI showError:@"请先选择客户"];
        }
    }else{
        [self setCurrentPage:nextPage];
    }
}


///挂单
- (IBAction)areCancelOrderAction:(id)sender
{
    if ([[IPCShoppingCart sharedCart] allGlassesCount] > 0 ) {
        if ([[IPCPayOrderManager sharedManager] currentCustomer]) {
            [self offerOrder:@"NULL" EndStatus:@"PROTOTYPE" Complete:^{
                [IPCCommonUI showSuccess:@"订单保存成功！"];
            }];
        }else{
            [IPCCommonUI showError:@"请先选择客户"];
        }
    }else{
        [IPCCommonUI showError:@"购物列表为空"];
    }
}

- (IBAction)cancelAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [IPCCommonUI showAlert:@"温馨提示" Message:@"您确定要取消该订单并清空购物列表及客户信息吗?" Owner:self DoneTitle:@"确定" CancelTitle:@"返回" Done:^{
        [weakSelf clearAllPayInfo];
    }];
}

- (IBAction)changePageIndex:(UIButton *)sender
{
    if (sender.tag == 3 && [[IPCPayOrderManager sharedManager] extraDiscount]) {
        [self offerOrderAction];
    }else{
        [self setCurrentPage:sender.tag];
    }
}

///超额打折提交订单
- (void)offerOrderAction
{
    __weak typeof(self) weakSelf = self;
    [IPCCommonUI showAlert:@"温馨提示" Message:@"该订单超额打折，请先提交订单！" Owner:self  DoneTitle:@"提交" CancelTitle:@"取消" Done:^{
        if ([[IPCShoppingCart sharedCart] allGlassesCount] > 0 ) {
            [weakSelf offerOrder:@"NULL" EndStatus:@"UN_AUDITED" Complete:^{
                [IPCCommonUI showSuccess:@"订单提交成功！"];
            }];
        }else{
            [IPCCommonUI showError:@"购物列表为空"];
        }
    }];
}


#pragma mark //Reload Methods
- (void)clearAllPayInfo
{
    [self setCurrentPage:0];
    [[IPCPayOrderManager sharedManager] resetData];
    [self.customerVC resetCustomerView];
}


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
        self.areCancelButtonWidth.constant = 0;
        [self.areCancelButton setHidden:YES];
    }else{
        [self.nextStepButton setHidden:NO];
        [self.saveButton setHidden:YES];
        self.areCancelButtonWidth.constant = 150;
        [self.areCancelButton setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
        self.viewControllers = nil;
        self.customerVC = nil;
        self.optometryVC = nil;
        self.offerOrderVC = nil;
        self.cashVC = nil;
        self.viewMode = nil;
        [IPCHttpRequest cancelAllRequest];
    }
}


@end
