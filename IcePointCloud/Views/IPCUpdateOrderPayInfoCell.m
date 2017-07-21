//
//  IPCPayOrderPayInfoCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/26.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCUpdateOrderPayInfoCell.h"

@implementation IPCUpdateOrderPayInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.produceIntegerLabel setText:[NSString stringWithFormat:@"本次消费产生积分%d点",[IPCCustomerOrderDetail instance].orderInfo.integral]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", [IPCCustomerOrderDetail instance].orderInfo.totalPayAmount]];
    
    if ([IPCCustomerOrderDetail instance].orderInfo.exchangeTotalIntegral > 0) {
        [self.useIntegerLabel setText:[NSString stringWithFormat:@"使用积分抵扣%.f点",[IPCCustomerOrderDetail instance].orderInfo.exchangeTotalIntegral]];
        [self.integerAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.totalPointAmount]];
    }else if ([IPCCustomerOrderDetail instance].orderInfo.deductionIntegral > 0){
        [self.useIntegerLabel setText:[NSString stringWithFormat:@"使用积分抵扣%.f点",[IPCCustomerOrderDetail instance].orderInfo.deductionIntegral]];
        [self.integerAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.integralDeductionAmount]];
    }else{
        [self.useIntegerLabel setText:@"使用积分抵扣0点"];
        [self.integerAmountLabel setText:@"-￥0.00"];
    }
    
    [self.givingAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomerOrderDetail instance].orderInfo.donationAmount]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
