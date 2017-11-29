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
        
        if ([self.currentCustomer.customerID isEqualToString:[IPCPayOrderManager sharedManager].currentCustomerId])
        {
            [self.customerNameLabel setTextColor:COLOR_RGB_BLUE];
            [self.customerPhoneLabel setTextColor:COLOR_RGB_BLUE];
            [self.customerLevelLabel setTextColor:COLOR_RGB_BLUE];
            [self addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
        }else{
            [self.customerNameLabel setTextColor:[UIColor jk_colorWithHexString:@"#666666"]];
            [self.customerPhoneLabel setTextColor:[UIColor jk_colorWithHexString:@"#888888"]];
            [self.customerLevelLabel setTextColor:[UIColor jk_colorWithHexString:@"#888888"]];
            [self addBorder:0 Width:0 Color:nil];
        }
    }
}

@end
