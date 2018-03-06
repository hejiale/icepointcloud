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
{
    BOOL isSelectMemberStatus;
}
@property (weak, nonatomic) IBOutlet UIView *customInfoContentView;
@property (weak, nonatomic) IBOutlet UIView *memberCardContentView;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *compulsoryVerifityView;
@property (weak, nonatomic) IBOutlet UILabel *unCheckMemberLabel;
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
    [self loadCustomerInfoView:nil];
    [self.rightContentView addSubview:self.customerListView];
    ///获取客户类别和门店
    [[IPCCustomerManager sharedManager] queryCustomerType];
    [[IPCCustomerManager sharedManager] queryStore];
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
            [weakSelf showEditCustomerView:YES];
        }];
        [[_memberNoneCustomerView rac_signalForSelector:@selector(createWithVistorAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf queryVisitorCustomer];
        }];
    }
    return _memberNoneCustomerView;
}

- (IPCPayOrderCustomerListView *)customerListView{
    if (!_customerListView) {
        __weak typeof(self) weakSelf = self;
        _customerListView = [[IPCPayOrderCustomerListView alloc]initWithFrame:self.rightContentView.bounds  IsChooseStatus:NO Detail:^(IPCCustomerMode* customer, BOOL isMemberReload)
                             {
                                 if (isMemberReload) {
                                     [weakSelf loadCustomerMemberInfoView:YES];
                                     [weakSelf queryMemberBindCustomer];
                                 }else{
                                     [weakSelf reloadCustomerInfo];
                                 }
                             } SelectType:^(BOOL isSelectMemeber) {
                                 isSelectMemberStatus = isSelectMemeber;
                             }];
        [[_customerListView rac_signalForSelector:@selector(insertCustomerAction:)]subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf showEditCustomerView:NO];
        }];
    }
    return _customerListView;
}

- (IPCPayOrderMemberChooseCustomerView *)chooseCustomerView{
    if (!_chooseCustomerView) {
        __weak typeof(self) weakSelf = self;
        _chooseCustomerView = [[IPCPayOrderMemberChooseCustomerView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds BindSuccess:^(IPCCustomerMode *customer)
                               {
                                   [IPCPayOrderCurrentCustomer sharedManager].currentMember = customer;
                                   [weakSelf loadCustomerInfoView:customer];
                               }];
    }
    return _chooseCustomerView;
}

- (IPCPayOrderMemberCustomerListView *)memberCustomerListView{
    if (!_memberCustomerListView) {
        __weak typeof(self) weakSelf = self;
        _memberCustomerListView = [[IPCPayOrderMemberCustomerListView alloc]initWithFrame:self.customInfoContentView.bounds Select:^(IPCCustomerMode *customer)
                                   {
                                       __strong typeof(weakSelf) strongSelf = weakSelf;
                                       [IPCPayOrderCurrentCustomer sharedManager].currentMember = customer;
                                       [weakSelf loadCustomerInfoView:customer];
                                       [strongSelf.viewModel queryCustomerOptometry];
                                   }];
    }
    return _memberCustomerListView;
}

#pragma mark //Load UI
- (void)loadCustomerInfoView:(IPCCustomerMode *)customer
{
    [self clearCustomerInfoView];
    
    if (customer) {
        [self.editButton setHidden:NO];
        [self.infoView updateCustomerInfo: customer];
        [self.customInfoContentView addSubview:self.infoView];
    }else{
        [self.editButton setHidden:YES];
        [self.customInfoContentView addSubview:self.customerAlertView];
    }
    [self resetCustomerData];
}

- (void)loadCustomerMemberInfoView:(BOOL)isChoose
{
    [self clearMemberInfoView];
    
    if ([IPCPayOrderManager sharedManager].currentCustomerId || [IPCPayOrderManager sharedManager].currentMemberCustomerId)
    {
        IPCCustomerMode * customer = nil;
        if (isChoose) {
            customer = [IPCPayOrderCurrentCustomer sharedManager].currentMember;
            [self.memberInfoView updateMemberCardInfo:[IPCPayOrderCurrentCustomer sharedManager].currentMember];
            [self.memberCardContentView addSubview:self.memberInfoView];
        }else{
            customer = [IPCPayOrderCurrentCustomer sharedManager].currentCustomer;
            if ([IPCPayOrderCurrentCustomer sharedManager].currentCustomer.memberLevel) {
                [self.memberInfoView updateMemberCardInfo:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer];
                [self.memberCardContentView addSubview:self.memberInfoView];
            }else{
                [self.memberCardContentView addSubview:self.customerUpgradeMemberView];
            }
        }
        if (customer.memberLevel && ![IPCAppManager sharedManager].companyCofig.isCheckMember) {
            if (![IPCPayOrderManager sharedManager].isValiateMember){
                if ([IPCAppManager sharedManager].authList.forceVerifyMember) {
                    [self.unCheckMemberLabel setHidden:NO];
                    [self.compulsoryVerifityView setHidden:NO];
                }else{
                    [self.unCheckMemberLabel setHidden:NO];
                }
            }
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
    [self.editButton setHidden:YES];
    
    if (customerList.count) {
        if (customerList.count > 1) {
            [self clearCustomerInfoView];
            [self.memberCustomerListView reloadCustomerListView:customerList];
            [self.customInfoContentView addSubview:self.memberCustomerListView];
        }else{
            IPCCustomerMode * customer = customerList[0];
            [IPCPayOrderCurrentCustomer sharedManager].currentMember = customer;
            [self loadCustomerInfoView:customer];
            [self.viewModel queryCustomerOptometry];
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
    [self.unCheckMemberLabel setHidden:YES];
    [self.compulsoryVerifityView setHidden:YES];
}

#pragma mark //Request Data
- (void)validationMemberRequest:(NSString *)code
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel validationMemberRequest:code Complete:^(IPCCustomerMode * customer)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        isSelectMemberStatus = YES;
        [strongSelf.customerListView changeToMemberStatus];
    
        [IPCPayOrderManager sharedManager].currentCustomerId = nil;
        [IPCPayOrderCurrentCustomer sharedManager].currentCustomer = nil;
        
        [IPCPayOrderCurrentCustomer sharedManager].currentMember = customer;
        [IPCPayOrderManager sharedManager].currentMemberCustomerId = customer.memberCustomerId;
        [IPCPayOrderManager sharedManager].customDiscount = [[IPCShoppingCart sharedCart] customDiscount];
        
        [weakSelf loadCustomerMemberInfoView:YES];
        [weakSelf queryMemberBindCustomer];
    }];
}

- (void)queryMemberBindCustomer
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryBindMemberCustomer:^(NSArray *customerList, NSError *error) {
        [weakSelf loadMemberCustomerListView:customerList];
    }];
}

- (void)queryVisitorCustomer
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryVisitorCustomer:^ {
        [weakSelf clearCustomerInfoView];
        [weakSelf loadCustomerInfoView:[IPCPayOrderCurrentCustomer sharedManager].currentMember];
    }];
}

- (void)bindMember:(IPCCustomerMode *)customer
{
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager bindMemberWithCustomerId:customer.customerID
                                       MemberCustomerId:[IPCPayOrderManager sharedManager].currentMemberCustomerId
                                           SuccessBlock:^(id responseValue)
     {
         [IPCPayOrderCurrentCustomer sharedManager].currentMember = [IPCCustomerMode mj_objectWithKeyValues:responseValue];
         [weakSelf clearCustomerInfoView];
         [weakSelf loadCustomerInfoView:[IPCPayOrderCurrentCustomer sharedManager].currentMember];
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:error.domain];
     }];
}

#pragma mark //Clicked Events
- (IBAction)validationMemberAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    IPCScanCodeViewController *scanVc = [[IPCScanCodeViewController alloc] initWithFinish:^(NSString *result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.cameraNav dismissViewControllerAnimated:YES completion:nil];
        [weakSelf validationMemberRequest:result];
    }];
    self.cameraNav = [[IPCPortraitNavigationViewController alloc]initWithRootViewController:scanVc];
    [self presentViewController:self.cameraNav  animated:YES completion:nil];
}

- (void)showEditCustomerView:(BOOL)isBindNewCustomer
{
    __weak typeof(self) weakSelf = self;
    self.editCustomerView = [[IPCEditCustomerView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                          UpdateBlock:^(IPCCustomerMode * customer)
                             {
                                 __strong typeof(weakSelf) strongSelf = weakSelf;
                                 if (isSelectMemberStatus) {
                                     [weakSelf bindMember:customer];
                                 }else{
                                     [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
                                     [IPCPayOrderCurrentCustomer sharedManager].currentCustomer = customer;
                                     [weakSelf loadCustomerInfoView:customer];
                                     [weakSelf loadCustomerMemberInfoView:NO];
                                     [strongSelf.customerListView loadData];
                                 }
                             }];
    [[IPCCommonUI currentView] addSubview:self.editCustomerView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.editCustomerView];
}

- (IBAction)updateCustomerAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    self.updateCustomerView = [[IPCUpdateCustomerView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                           DetailCustomer:isSelectMemberStatus ? [IPCPayOrderCurrentCustomer sharedManager].currentMember : [IPCPayOrderCurrentCustomer sharedManager].currentCustomer
                                                              UpdateBlock:^(IPCCustomerMode * customer)
                               {
                                   __strong typeof(weakSelf) strongSelf = weakSelf;
                                   if (isSelectMemberStatus) {
                                       [IPCPayOrderCurrentCustomer sharedManager].currentMember = customer;
                                   }else{
                                       [IPCPayOrderCurrentCustomer sharedManager].currentCustomer = customer;
                                   }
                                   [weakSelf loadCustomerInfoView:customer];
                                   [strongSelf.customerListView loadData];
                               }];
    [[IPCCommonUI currentView] addSubview:self.updateCustomerView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.updateCustomerView];
}


- (void)showUpgradeMemberView
{
    __weak typeof(self) weakSelf = self;
    self.upgradeMemberView = [[IPCUpgradeMemberView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                               Customer:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer
                                                            UpdateBlock:^(IPCCustomerMode *customer)
                              {
                                  __strong typeof(weakSelf) strongSelf = weakSelf;
                                  [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
                                  [IPCPayOrderCurrentCustomer sharedManager].currentCustomer = customer;
                                  [weakSelf loadCustomerMemberInfoView:NO];
                                  [strongSelf.customerListView loadData];
                              }];
    [[IPCCommonUI currentView] addSubview:self.upgradeMemberView];
    [[IPCCommonUI currentView] bringSubviewToFront:self.upgradeMemberView];
}


- (IBAction)compulsoryVerificationAction:(id)sender {
    [IPCPayOrderManager sharedManager].isValiateMember = YES;
    [IPCPayOrderManager sharedManager].customDiscount = [[IPCShoppingCart sharedCart] customDiscount];
    [self loadCustomerMemberInfoView:isSelectMemberStatus];
}

- (void)reloadCustomerInfo
{
    [self loadCustomerInfoView:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer];
    [self loadCustomerMemberInfoView:NO];
    [self.viewModel queryCustomerOptometry];
}

- (void)resetCustomerData
{
    [[IPCPayOrderManager sharedManager] clearPayRecord];
    [[IPCPayOrderManager sharedManager] resetCustomerDiscount];
    [[IPCPayOrderManager sharedManager] calculatePayAmount];
}

- (void)resetCustomerView
{
    [self loadCustomerInfoView:nil];
    [self loadCustomerMemberInfoView:NO];
    [self.customerListView loadData];
    [self.editButton setHidden:YES];
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
