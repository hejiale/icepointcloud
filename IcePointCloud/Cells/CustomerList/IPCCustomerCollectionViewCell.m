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
}


- (void)setCurrentCustomer:(IPCCustomerMode *)currentCustomer{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer)
    {
        NSString * pointText = @"0积分";
        
        if (_currentCustomer.integral) {
            pointText = [NSString stringWithFormat:@"%@积分",_currentCustomer.integral];
        }
    
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.customerPhoneLabel setText:_currentCustomer.customerPhone];
        [self.pointLabel setText:pointText];
        
        if (_currentCustomer.memberLevel && _currentCustomer.memberLevel.length) {
            [self.memberLevelLabel setText:_currentCustomer.memberLevel];
        }else{
            [self.memberLevelLabel setText:@""];
        }
    }
}

@end
