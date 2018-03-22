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


- (void)setOrderInfo:(IPCCustomerOrderInfo *)orderInfo{
    _orderInfo = orderInfo;
    
    if (_orderInfo) {
        [self.realTotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",_orderInfo.totalSuggestAmount]];
        [self.givingAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",_orderInfo.totalDonationAmount]];
        [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",_orderInfo.totalPayAmount]];
    }
}



@end
