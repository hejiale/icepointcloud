//
//  IPCPayOrderCustomerViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerViewController.h"
#import "IPCPayOrderCustomInfoView.h"
#import "IPCPayOrderCustomerMemberInfoView.h"
#import "IPCPayOrderCustomerAlertView.h"
#import "IPCPayOrderCustomerMemberAlertView.h"
#import "IPCPayOrderCustomerUpgradeMemberView.h"
#import "IPCPayOrderMemberNoneCustomerView.h"
#import "IPCPayOrderMemberCustomerListView.h"
#import "IPCCustomerListViewModel.h"
#import "IPCEditCustomerView.h"
#import "IPCUpdateCustomerView.h"
#import "IPCUpgradeMemberView.h"
#import "IPCScanCodeViewController.h"
#import "IPCPayOrderCustomerListView.h"
#import "IPCPayOrderMemberChooseCustomerView.h"

@interface IPCPayOrderCustomerViewController ()

@property (weak, nonatomic) IBOutlet UIView *customInfoContentView;
@property (weak, nonatomic) IBOutlet UIView *memberCardContentView;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;
@property (nonatomic, strong) IPCCustomerListViewModel    * viewModel;
@property (nonatomic, strong) IPCPayOrderCustomInfoView * infoView;
@property (nonatomic, strong) IPCPayOrderCustomerMemberInfoView * memberInfoView;
@property (nonatomic, strong) IPCPayOrderCustomerAlertView *customerAlertView;
@property (nonatomic, strong) IPCPayOrderCustomerMemberAlertView *memberAlertView;
@property (nonatomic, strong) IPCPayOrderCustomerUpgradeMemberView * customerUpgradeMemberView;
@property (nonatomic, strong) IPCPayOrderMemberNoneCustomerView * memberNoneCustomerView;
@property (nonatomic, strong) IPCEditCustomerView * editCustomerView;
@property (nonatomic, strong) IPCUpdateCustomerView * updateCustomerView;
@property (nonatomic, strong) IPCUpgradeMemberView * upgradeMemberView;
@property (nonatomic, strong) IPCPortraitNavigationViewController * cameraNav;
@property (nonatomic, strong) IPCPayOrderCustomerListView * customerListView;
@property (nonatomic, strong) IPCPayOrderMemberChooseCustomerView * chooseCustomerView;
@property (nonatomic, strong) IPCPayOrderMemberCustomerListView * memberCustomerListView;

@end

@implementation IPCPayOrderCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Init Data
    self.viewModel = [[IPCCustomerListViewModel alloc]init];
    //Load UI
    [self loadCustomerInfoView];
    [self.rightContentView addSubview:self.customerListView];
    ///获取客户类别和门店
    [[IPCCustomerManager sharedManager] queryCustomerType];
    [[IPCCustomerManager sharedManager] queryStore];
    //KVO
//    [[IPCPayOrderManager sharedManager] ipc_addObserver:self ForKeyPath:@"currentCustomerId"];
//    [[IPCPayOrderManager sharedManager] ipc_addObserver:self ForKeyPath:@"currentMemberCustomerId"];
}

#pragma mark //Set UI
- (IPCPayOrderCustomInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[IPCPayOrderCustomInfoView alloc]initWithFrame:self.customInfoContentView.bounds];
    }
    return _infoView;
}

- (IPCPayOrderCustomerMemberInfoView *)memberInfoView{
    if (!_memberInfoView) {
        _memberInfoView = [[IPCPayOrderCustomerMemberInfoView alloc]initWithFrame:self.memberCardContentView.bounds];
    }
    return _memberInfoView;
}

- (IPCPayOrderCustomerAlertView *)customerAlertView{
    if (!_customerAlertView) {
        __weak typeof(self) weakSelf = self;
        _customerAlertView = [[IPCPayOrderCustomerAlertView alloc]initWithFrame:self.customInfoContentView.bounds];
        [[_customerAlertView rac_signalForSelector:@selector(insertAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf showEditCustomerView];
        }];
    }
    return _customerAlertView;
}

- (IPCPayOrderCustomerUpgradeMemberView *)customerUpgradeMemberView{
    if (!_customerUpgradeMemberView) {
        __weak typeof(self) weakSelf = self;
        _customerUpgradeMemberView = [[IPCPayOrderCustomerUpgradeMemberView alloc]initWithFrame:self.memberCardContentView.bounds];
        [[_customerUpgradeMemberView rac_signalForSelector:@selector(upgradeMemberAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf showUpgradeMemberView];
        }];
    }
    return _customerUpgradeMemberView;
}

- (IPCPayOrderCustomerMemberAlertView *)memberAlertView{
    if (!_memberAlertView) {
        _memberAlertView = [[IPCPayOrderCustomerMemberAlertView alloc]initWithFrame:self.memberCardContentView.bounds];
    }
    return _memberAlertView;
}

- (IPCPayOrderMemberNoneCustomerView *)memberNoneCustomerView{
    if (!_memberNoneCustomerView) {
        __weak typeof(self) weakSelf = self;
        _memberNoneCustomerView = [[IPCPayOrderMemberNoneCustomerView alloc]initWithFrame:self.customInfoContentView.bounds];
        [[_memberNoneCustomerView rac_signalForSelector:@selector(bindCustomerAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf loadMemberChooseCustomerView];
        }];
        [[_memberNoneCustomerView rac_signalForSelector:@selector(createCustomerAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf showEditCustomerView];
        }];
    }
    return _memberNoneCustomerView;
}

- (IPCPayOrderCustomerListView *)customerListView{
    if (!_customerListView) {
        __weak typeof(self) weakSelf = self;
        _customerListView = [[IPCPayOrderCustomerListView alloc]initWithFrame:self.rightContentView.bounds  IsChooseStatus:NO Detail:^(IPCDetailCustomer * customer, BOOL isMemberReload)
        {
            if (isMemberReload) {
                [weakSelf loadCustomerMemberInfoView];
                [weakSelf queryMemberBindCustomer];
            }else{
                [weakSelf reloadCustomerInfo];
            }
        }];
    }
    return _customerListView;
}

- (IPCPayOrderMemberChooseCustomerView *)chooseCustomerView{
    if (!_chooseCustomerView) {
        __weak typeof(self) weakSelf = self;
        _chooseCustomerView = [[IPCPayOrderMemberChooseCustomerView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds BindSuccess:^(NSString *customerId)
        {
            [weakSelf queryCustomerDetail:customerId];
        }];
    }
    return _chooseCustomerView;
}

- (IPCPayOrderMemberCustomerListView *)memberCustomerListView{
    if (!_memberCustomerListView) {
        __weak typeof(self) weakSelf = self;
        _memberCustomerListView = [[IPCPayOrderMemberCustomerListView alloc]initWithFrame:self.customInfoContentView.bounds Select:^(NSString *customerId)
        {
            [weakSelf queryCustomerDetail:customerId];
        }];
    }
    return _memberCustomerListView;
}

#pragma mark //Load UI
- (void)loadCustomerInfoView
{
    [self clearCustomerInfoView];
    
    if ([IPCPayOrderManager sharedManager].currentCustomerId) {
        [self.infoView updateCustomerInfo:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer];
        [self.customInfoContentView addSubview:self.infoView];
    }else{
        [self.customInfoContentView addSubview:self.customerAlertView];
    }
}

- (void)loadCustomerMemberInfoView
{
    [self clearMemberInfoView];
    
    if ([IPCPayOrderManager sharedManager].currentCustomerId || [IPCPayOrderManager sharedManager].currentMemberCustomerId)
    {
        if ([IPCPayOrderCurrentCustomer sharedManager].currentCustomer.memberLevel)
        {
            [self.memberInfoView updateMemberInfo];
            [self.memberCardContentView addSubview:self.memberInfoView];
        }else if ([IPCPayOrderCurrentCustomer sharedManager].currentMember){
            [self.memberInfoView updateMemberCardInfo];
            [self.memberCardContentView addSubview:self.memberInfoView];
        } else{
            [self.memberCardContentView addSubview:self.customerUpgradeMemberView];
        }
    }else{
        [self.memberCardContentView addSubview:self.memberAlertView];
    }
}

- (void)loadMemberChooseCustomerView
{
    if (self.chooseCustomerView) {
        [self.chooseCustomerView removeFromSuperview];
        self.chooseCustomerView = nil;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.chooseCustomerView];
}

- (void)loadMemberCustomerListView:(NSArray<IPCCustomerMode *> *)customerList
{
    [self clearCustomerInfoView];
    
    if (customerList.count) {
        if (customerList.count > 1) {
            [self clearCustomerInfoView];
            [self.memberCustomerListView reloadCustomerListView:customerList];
            [self.customInfoContentView addSubview:self.memberCustomerListView];
        }else{
            IPCCustomerMode * customer = customerList[0];
            [self queryCustomerDetail:customer.customerID];
        }
    }else{
        [self.customInfoContentView addSubview:self.memberNoneCustomerView];
    }
}

#pragma mark //Clear All Views
- (void)clearCustomerInfoView
{
    [self.infoView removeFromSuperview];self.infoView = nil;
    [self.customerAlertView removeFromSuperview];self.customerAlertView = nil;
    [self.memberNoneCustomerView removeFromSuperview];self.memberNoneCustomerView = nil;
    [self.memberCustomerListView removeFromSuperview];self.memberCustomerListView = nil;
}

- (void)clearMemberInfoView
{
    [self.memberInfoView removeFromSuperview];self.memberInfoView = nil;
    [self.memberAlertView removeFromSuperview];self.memberAlertView = nil;
    [self.customerUpgradeMemberView removeFromSuperview];self.customerUpgradeMemberView = nil;
}

#pragma mark //Request Data
- (void)validationMemberRequest:(NSString *)code
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel validationMemberRequest:code Complete:^{
        [weakSelf reloadCustomerInfo];
    }];
}

- (void)queryMemberBindCustomer
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryBindMemberCustomer:^(NSArray *customerList, NSError *error) {
        [weakSelf loadMemberCustomerListView:customerList];
    }];
}

- (void)queryCustomerDetail:(NSString *)customerId
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryCustomerDetailWithStatus:YES CustomerId:customerId Complete:^(IPCDetailCustomer *customer)
    {
        [IPCPayOrderManager sharedManager].currentBindCustomerId = customerId;
        [IPCPayOrderCurrentCustomer sharedManager].currentCustomer = customer;
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [weakSelf clearCustomerInfoView];
        [strongSelf.infoView updateCustomerInfo:customer];
        [strongSelf.customInfoContentView addSubview:strongSelf.infoView];
    }];
}

#pragma mark //Clicked Events
//- (IBAction)insertNewCustomerAction:(id)sender
//{
//    [self showEditCustomerView];
//}
//
//- (IBAction)validationMemberAction:(id)sender
//{
//    __weak typeof(self) weakSelf = self;
//    IPCScanCodeViewController *scanVc = [[IPCScanCodeViewController alloc] initWithFinish:^(NSString *result, NSError *error) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.cameraNav dismissViewControllerAnimated:YES completion:nil];
//        [weakSelf validationMemberRequest:result];
//    }];
//    self.cameraNav = [[IPCPortraitNavigationViewController alloc]initWithRootViewController:scanVc];
//    [self presentViewController:self.cameraNav  animated:YES completion:nil];
//}

- (void)showEditCustomerView
{
    __weak typeof(self) weakSelf = self;
    self.editCustomerView = [[IPCEditCustomerView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                          UpdateBlock:^(NSString *customerId)
                             {
                               
                             }];
    [[IPCCommonUI currentView] addSubview:self.editCustomerView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.editCustomerView];
}

- (void)showUpdateCustomerView
{
    __weak typeof(self) weakSelf = self;
    self.updateCustomerView = [[IPCUpdateCustomerView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                           DetailCustomer:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer
                                                              UpdateBlock:^(NSString *customerId)
                               {
                          
                               }];
    [[IPCCommonUI currentView] addSubview:self.updateCustomerView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.updateCustomerView];
}

- (void)showUpgradeMemberView
{
    __weak typeof(self) weakSelf = self;
    self.upgradeMemberView = [[IPCUpgradeMemberView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                               Customer:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer
                                                            UpdateBlock:^
                              {
                                  [IPCCommonUI showSuccess:@"客户升级会员成功!"];
                                  [IPCPayOrderManager sharedManager].isValiateMember = YES;
                                  [weakSelf performSelector:@selector(queryCustomerDetail) withObject:nil afterDelay:1.f];
                                  [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
                              }];
    [[IPCCommonUI currentView] addSubview:self.upgradeMemberView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.upgradeMemberView];
}

- (void)reloadCustomerInfo
{
    [[IPCPayOrderManager sharedManager] clearPayRecord];
    [[IPCPayOrderManager sharedManager] resetCustomerDiscount];
    [[IPCPayOrderManager sharedManager] calculatePayAmount];
    
    [self loadCustomerInfoView];
    [self loadCustomerMemberInfoView];
}

#pragma mark //KVO
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"currentCustomerId"])
//    {
//
//    }
//}

- (void)resetCustomerView
{
    [self loadCustomerInfoView];
    [self loadCustomerMemberInfoView];
    [self.customerListView reload];
    [IPCPayOrderManager sharedManager].isValiateMember = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
        self.infoView = nil;
        self.editCustomerView = nil;
        self.upgradeMemberView = nil;
        self.updateCustomerView = nil;
        self.cameraNav = nil;
        self.viewModel = nil;
        [IPCHttpRequest cancelAllRequest];
    }
}


@end
