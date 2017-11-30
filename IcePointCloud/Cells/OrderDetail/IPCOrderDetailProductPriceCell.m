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
    
    [self.realTotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.totalSuggestPrice]];
    //抵扣积分  兑换积分 定制商品
    if ([IPCCustomerOrderDetail instance].orderInfo.exchangeTotalIntegral > 0) {
        [self.usedPointLabel setText:[NSString stringWithFormat:@"使用积分%.f点",[IPCCustomerOrderDetail instance].orderInfo.exchangeTotalIntegral]];
        [self.usePointAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.totalPointAmount]];
    }else if ([IPCCustomerOrderDetail instance].orderInfo.deductionIntegral > 0){
        [self.usedPointLabel setText:[NSString stringWithFormat:@"使用积分%.f点",[IPCCustomerOrderDetail instance].orderInfo.deductionIntegral]];
        [self.usePointAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.integralDeductionAmount]];
    }else{
        [self.usedPointLabel setText:@"使用积分0点"];
        [self.usePointAmountLabel setText:@"-￥0.00"];
    }
    [self.givingAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.donationAmount]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.totalPrice]];
    
}

@end
