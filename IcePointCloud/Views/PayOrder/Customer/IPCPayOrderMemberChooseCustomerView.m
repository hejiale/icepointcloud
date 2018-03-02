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
@property (strong, nonatomic) IPCPayOrderCustomerListView * customListView;
@property (strong, nonatomic) IPCPayOrderCustomInfoView * customerInfoView;
@property (strong, nonatomic) IPCDetailCustomer * detailCustomer;
@property (copy, nonatomic) void(^BindSuccessBlock)(NSString *customerId);

@end

@implementation IPCPayOrderMemberChooseCustomerView

- (instancetype)initWithFrame:(CGRect)frame BindSuccess:(void(^)(NSString *customerId))success
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderMemberChooseCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    
        self.BindSuccessBlock = success;
        [self.rightContentView addSubview:self.customListView];
    }
    return self;
}

#pragma mark //Set UI
- (IPCPayOrderCustomerListView *)customListView{
    if (!_customListView) {
        __weak typeof(self) weakSelf = self;
        _customListView = [[IPCPayOrderCustomerListView alloc]initWithFrame:self.rightContentView.bounds IsChooseStatus:YES Detail:^(IPCDetailCustomer *customer, BOOL isMemberReload)
        {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.detailCustomer = customer;
            [weakSelf loadCustomerInfoView:customer];
        }];
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
    [IPCCustomerRequestManager bindMemberWithCustomerId:self.detailCustomer.customerID MemberCustomerId:[IPCPayOrderManager sharedManager].currentMemberCustomerId SuccessBlock:^(id responseValue)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.BindSuccessBlock) {
            strongSelf.BindSuccessBlock(strongSelf.detailCustomer.customerID);
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

- (void)loadCustomerInfoView:(IPCDetailCustomer *)customer
{
    if (self.customerInfoView) {
        [self.customerInfoView removeFromSuperview];
        self.customerInfoView = nil;
    }
    [self.customerInfoView updateCustomerInfo:customer];
    [self.leftContentView addSubview:self.customerInfoView];
}

@end
