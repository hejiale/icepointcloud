//
//  IPCPayOrderOrderListViewCell.m
//  IcePointCloud
//
//  Created by gerry on 2018/3/21.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderOrderListViewCell.h"

@implementation IPCPayOrderOrderListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomerOrder:(IPCCustomerOrderMode *)customerOrder{
    _customerOrder = customerOrder;
    
    if (_customerOrder) {
        [self.orderCodeLabel setText:_customerOrder.orderCode];
        
        [self.orderPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",_customerOrder.orderPrice]];
        
        [self.orderDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:_customerOrder.orderDate] IsTime:YES]];
        
        [self.orderStatusLabel setText:[_customerOrder orderStatus]];
    }
}

@end
