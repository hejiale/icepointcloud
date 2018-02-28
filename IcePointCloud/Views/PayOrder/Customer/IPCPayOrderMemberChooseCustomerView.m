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

@end

@implementation IPCPayOrderMemberChooseCustomerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderMemberChooseCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    
        [self.rightContentView addSubview:self.customListView];
    }
    return self;
}

#pragma mark //Set UI
- (IPCPayOrderCustomerListView *)customListView{
    if (!_customListView) {
        __weak typeof(self) weakSelf = self;
        _customListView = [[IPCPayOrderCustomerListView alloc]initWithFrame:self.rightContentView.bounds IsChooseStatus:YES Detail:^(IPCDetailCustomer *customer) {
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

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}


- (IBAction)saveAction:(id)sender {
    [self removeFromSuperview];
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
