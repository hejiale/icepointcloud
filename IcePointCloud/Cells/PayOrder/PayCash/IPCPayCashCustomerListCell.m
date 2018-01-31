//
//  IPCPayCashCustomerListCell.m
//  IcePointCloud
//
//  Created by gerry on 2018/1/31.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayCashCustomerListCell.h"

@implementation IPCPayCashCustomerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomer:(IPCCustomerMode *)customer
{
    _customer = customer;
    
    if (_customer) {
        [self.customerNameLabel setText:_customer.customerName];
        [self.phoneLabel setText:_customer.customerPhone];
    }
}

@end
