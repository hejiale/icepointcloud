//
//  OrderDetailContactCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderDetailContactCell.h"

@implementation IPCOrderDetailContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)inputContactInfo:(IPCCustomerOrderInfo *)customer
{
    [self.contactNameLabel setText:[NSString stringWithFormat:@"收货人: %@",customer.customerName]];
    [self.contactPhoneLabel setText:[NSString stringWithFormat:@"%@",customer.customerMobilePhone]];
    [self.contactAddressLabel setText:customer.customerAddress];
    
    CGFloat height = [self.contactAddressLabel.text jk_heightWithFont:self.contactAddressLabel.font constrainedToWidth:self.contactAddressLabel.jk_width];
    if (height >= 35) {
        self.addressHeightConstraint.constant = 35;
    }else{
        self.addressHeightConstraint.constant = MAX(height, 20);
    }
}


@end
