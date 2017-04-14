//
//  CustomerCollectionViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerCollectionViewCell.h"

@implementation IPCCustomerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self addBorder:5 Width:0.5];
}


- (void)setCurrentCustomer:(IPCCustomerMode *)currentCustomer{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer) {
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.customerPhoneLabel setText:_currentCustomer.customerPhone];
        [self.pointLabel setText:[NSString stringWithFormat:@"%@积分",_currentCustomer.integral]];
        if (_currentCustomer.memberLevel && _currentCustomer.memberLevel.length) {
            [self.memberLevelLabel setText:_currentCustomer.memberLevel];
        }
    }
}

@end
