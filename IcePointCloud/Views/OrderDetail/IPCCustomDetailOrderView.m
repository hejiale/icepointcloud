//
//  IPCCustomDetailOrderView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomDetailOrderView.h"
#import "IPCOrderDetailView.h"

@interface IPCCustomDetailOrderView()
{
    NSString * _orderNum;
}
@property (nonatomic, strong) IPCOrderDetailView * orderDetailView;

@end

@implementation IPCCustomDetailOrderView

- (instancetype)initWithFrame:(CGRect)frame
                     OrderNum:(NSString *)orderNum
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view  = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomDetailOrderView" owner:self];
        [view setFrame:frame];
        [self addSubview: view];
        
        _orderNum = orderNum;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    //Load OrderDetail View
    [self addSubview:self.orderDetailView];
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.mas_equalTo(400);
    }];
}


- (IPCOrderDetailView *)orderDetailView
{
    if (!_orderDetailView) {
        _orderDetailView = [[IPCOrderDetailView alloc]initWithOrderDetail:nil];
        [_orderDetailView setOrderNum:_orderNum];
    }
    return _orderDetailView;
}


#pragma mark //Clicked Events
- (IBAction)dismissViewAction:(id)sender
{
    [self removeFromSuperview];
}



@end
