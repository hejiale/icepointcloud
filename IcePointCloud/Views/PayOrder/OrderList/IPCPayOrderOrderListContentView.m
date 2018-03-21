//
//  IPCPayOrderCustomerOrderListView.m
//  IcePointCloud
//
//  Created by gerry on 2018/3/21.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderOrderListContentView.h"
#import "IPCPayOrderOrderListView.h"
#import "IPCOrderDetailView.h"

@interface IPCPayOrderOrderListContentView()

@property (weak, nonatomic) IBOutlet UIView *leftContentView;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;
@property (strong, nonatomic) IPCPayOrderOrderListView * orderListView;
@property (strong, nonatomic) IPCOrderDetailView * orderDetailView;

@end


@implementation IPCPayOrderOrderListContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOrderListContentView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftContentView addSubview:self.orderListView];
}

#pragma mark //Set UI
- (IPCPayOrderOrderListView *)orderListView
{
    if (!_orderListView) {
        _orderListView = [[IPCPayOrderOrderListView alloc]initWithFrame:self.leftContentView.bounds
                                                               Complete:^(NSString *orderNum)
                          {
                              [self loadOrderDetailViewWithOrderNum:orderNum];
                          }];
    }
    return _orderListView;
}

- (IPCOrderDetailView *)orderDetailView{
    if (!_orderDetailView) {
        _orderDetailView = [[IPCOrderDetailView alloc]init];
    }
    return _orderDetailView;
}

#pragma mark //Clicked Events
- (void)loadOrderDetailViewWithOrderNum:(NSString *)orderNum
{
    if (self.orderDetailView) {
        [self.orderDetailView removeFromSuperview];
        self.orderDetailView = nil;
    }
    [self.rightContentView addSubview:self.orderDetailView];
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightContentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.rightContentView.mas_bottom).with.offset(0);
        make.left.equalTo(self.rightContentView.mas_left).with.offset(0);
        make.right.equalTo(self.rightContentView.mas_right).with.offset(0);
    }];
    [self.orderDetailView setOrderNum:orderNum];
}


- (IBAction)dismissAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)payCashAction:(id)sender {
    [self removeFromSuperview];
}


@end
