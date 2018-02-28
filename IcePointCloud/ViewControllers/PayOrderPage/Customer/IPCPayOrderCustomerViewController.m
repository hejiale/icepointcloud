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
    [[IPCPayOrderManager sharedManager] ipc_addObserver:self ForKeyPath:@"currentCustomerId"];
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
        _customerAlertView = [[IPCPayOrderCustomerAlertView alloc]initWithFrame:self.customInfoContentView.bounds];
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
    }
    return _memberNoneCustomerView;
}

- (IPCPayOrderCustomerListView *)customerListView{
    if (!_customerListView) {
        __weak typeof(self) weakSelf = self;
        _customerListView = [[IPCPayOrderCustomerListView alloc]initWithFrame:self.rightContentView.bounds  IsChooseStatus:NO Detail:^(IPCDetailCustomer * customer){
            [weakSelf reloadCustomerInfo];
        }];
    }
    return _customerListView;
}

- (IPCPayOrderMemberChooseCustomerView *)chooseCustomerView{
    if (!_chooseCustomerView) {
        _chooseCustomerView = [[IPCPayOrderMemberChooseCustomerView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    }
    return _chooseCustomerView;
}

- (void)loadCustomerInfoView
{
    if (self.infoView) {
        [self.infoView removeFromSuperview];
        self.infoView = nil;
    }
    if (self.customerAlertView) {
        [self.customerAlertView removeFromSuperview];
        self.customerAlertView = nil;
    }
    if (self.memberAlertView) {
        [self.memberAlertView removeFromSuperview];
        self.memberAlertView = nil;
    }
    if (self.memberNoneCustomerView) {
        [self.memberNoneCustomerView removeFromSuperview];
        self.memberNoneCustomerView = nil;
    }
    if ([IPCPayOrderManager sharedManager].currentCustomerId) {
        [self.infoView updateCustomerInfo:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer];
        [self.customInfoContentView addSubview:self.infoView];
    }else{
        [self.customInfoContentView addSubview:self.memberNoneCustomerView];
        [self.memberCardContentView addSubview:self.memberAlertView];
    }
}

- (void)loadCustomerMemberInfoView
{
    if (self.memberInfoView) {
        [self.memberInfoView removeFromSuperview];
        self.memberInfoView = nil;
    }
    if (self.customerUpgradeMemberView) {
        [self.customerUpgradeMemberView removeFromSuperview];
        self.customerUpgradeMemberView = nil;
    }
    if ([IPCPayOrderCurrentCustomer sharedManager].currentCustomer.memberLevel) {
        [self.memberInfoView updateCustomerInfo];
        [self.memberCardContentView addSubview:self.memberInfoView];
    }else{
        [self.memberCardContentView addSubview:self.customerUpgradeMemberView];
    }
}

- (void)loadMemberChooseCustomerView
{
    if (self.chooseCustomerView) {
        self.chooseCustomerView = nil;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.chooseCustomerView];
}


#pragma mark //Request Data
- (void)validationMemberRequest:(NSString *)code
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel validationMemberRequest:code Complete:^{
        [weakSelf reloadCustomerInfo];
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

//- (void)showEditCustomerView
//{
//    __weak typeof(self) weakSelf = self;
//    self.editCustomerView = [[IPCEditCustomerView alloc]initWithFrame:[IPCCommonUI currentView].bounds
//                                                          UpdateBlock:^(NSString *customerId)
//                             {
//                                 [IPCPayOrderManager sharedManager].currentCustomerId = customerId;
//                                 [weakSelf loadData];
//                             }];
//    [[IPCCommonUI currentView] addSubview:self.editCustomerView];
//    [[IPCCommonUI currentView] bringSubviewToFront:self.editCustomerView];
//}
//
//- (void)showUpdateCustomerView
//{
//    __weak typeof(self) weakSelf = self;
//    self.updateCustomerView = [[IPCUpdateCustomerView alloc]initWithFrame:[IPCCommonUI currentView].bounds
//                                                           DetailCustomer:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer
//                                                              UpdateBlock:^(NSString *customerId)
//                               {
//                                   [weakSelf queryCustomerDetail];
//                                   [weakSelf loadData];
//                               }];
//    [[IPCCommonUI currentView] addSubview:self.updateCustomerView];
//    [[IPCCommonUI currentView] bringSubviewToFront:self.updateCustomerView];
//}

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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentCustomerId"])
    {
        if (![IPCPayOrderManager sharedManager].currentCustomerId) {
            [self loadCustomerInfoView];
            [self.customerListView reload];
            [IPCPayOrderManager sharedManager].isValiateMember = NO;
        }
    }
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
