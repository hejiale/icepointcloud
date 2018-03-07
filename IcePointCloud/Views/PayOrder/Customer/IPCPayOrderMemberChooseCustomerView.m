//
//  IPCPayOrderMemberChooseCustomerView.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/28.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderMemberChooseCustomerView.h"
#import "IPCPayOrderCustomerListView.h"
#import "IPCPayOrderCustomInfoView.h"

@interface IPCPayOrderMemberChooseCustomerView()

@property (weak, nonatomic) IBOutlet UIView *leftContentView;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IPCPayOrderCustomerListView * customListView;
@property (strong, nonatomic) IPCPayOrderCustomInfoView * customerInfoView;
@property (strong, nonatomic) IPCCustomerMode * customer;
@property (copy, nonatomic) void(^BindSuccessBlock)(IPCCustomerMode *customer);

@end

@implementation IPCPayOrderMemberChooseCustomerView

- (instancetype)initWithFrame:(CGRect)frame BindSuccess:(void(^)(IPCCustomerMode *customer))success
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderMemberChooseCustomerView" owner:self];
        [self addSubview:view];
    
        self.BindSuccessBlock = success;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.rightContentView addSubview:self.customListView];
    [self.cancelButton addBorder:3 Width:1 Color:COLOR_RGB_BLUE];
    [self.sureButton addBorder:3 Width:0 Color:nil];
}

#pragma mark //Set UI
- (IPCPayOrderCustomerListView *)customListView{
    if (!_customListView) {
        __weak typeof(self) weakSelf = self;
        _customListView = [[IPCPayOrderCustomerListView alloc]initWithFrame:self.rightContentView.bounds
                                                             IsChooseStatus:YES
                                                                     Detail:^(IPCCustomerMode *customer, BOOL isMemberReload)
        {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.customer = customer;
            [weakSelf loadCustomerInfoView:customer];
        } SelectType:nil];
    }
    return _customListView;
}

- (IPCPayOrderCustomInfoView *)customerInfoView{
    if (!_customerInfoView) {
        _customerInfoView = [[IPCPayOrderCustomInfoView alloc]initWithFrame:self.leftContentView.bounds];
    }
    return _customerInfoView;
}

#pragma mark //Request Data
- (void)bindMember
{
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager bindMemberWithCustomerId:self.customer.customerID
                                       MemberCustomerId:[IPCPayOrderManager sharedManager].currentMemberCustomerId
                                           SuccessBlock:^(id responseValue)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.BindSuccessBlock) {
            strongSelf.BindSuccessBlock(strongSelf.customer);
        }
        [self removeFromSuperview];
    } FailureBlock:^(NSError *error) {
        [IPCCommonUI showError:error.domain];
    }];
}

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}


- (IBAction)saveAction:(id)sender {
    [self bindMember];
}

- (void)loadCustomerInfoView:(IPCCustomerMode *)customer
{
    if (self.customerInfoView) {
        [self.customerInfoView removeFromSuperview];
        self.customerInfoView = nil;
    }
    [self.customerInfoView updateCustomerInfo:customer];
    [self.leftContentView addSubview:self.customerInfoView];
}

@end
