//
//  IPCPayOrderCustomerCollectionViewCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerCollectionViewCell.h"

@implementation IPCPayOrderCustomerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurrentCustomer:(IPCCustomerMode *)currentCustomer
{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer) {
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.customerPhoneLabel setText:_currentCustomer.customerPhone];
        [self.customerLevelLabel setText:_currentCustomer.memberLevel];
    }
}

@end
