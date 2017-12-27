//
//  OrderProductPriceCell.m
//  IcePointCloud
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderDetailProductPriceCell.h"

@implementation IPCOrderDetailProductPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.realTotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.totalSuggestAmount]];
    [self.givingAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.totalDonationAmount]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.totalPrice]];
    
}

@end
