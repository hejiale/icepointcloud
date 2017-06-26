//
//  IPCPayOrderPayInfoCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/26.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderPayInfoCell.h"

@implementation IPCPayOrderPayInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.produceIntegerLabel setText:[NSString stringWithFormat:@"本次消费产生积分%d点",[IPCCustomOrderDetailList instance].orderInfo.integral]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", [IPCCustomOrderDetailList instance].orderInfo.totalPayAmount]];
    
    if ([IPCCustomOrderDetailList instance].orderInfo.exchangeTotalIntegral > 0) {
        [self.useIntegerLabel setText:[NSString stringWithFormat:@"使用积分抵扣%.f点",[IPCCustomOrderDetailList instance].orderInfo.exchangeTotalIntegral]];
        [self.integerAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomOrderDetailList instance].orderInfo.totalPointAmount]];
    }else if ([IPCCustomOrderDetailList instance].orderInfo.deductionIntegral > 0){
        [self.useIntegerLabel setText:[NSString stringWithFormat:@"使用积分抵扣%.f点",[IPCCustomOrderDetailList instance].orderInfo.deductionIntegral]];
        [self.integerAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomOrderDetailList instance].orderInfo.integralDeductionAmount]];
    }else{
        [self.useIntegerLabel setText:@"使用积分抵扣0点"];
        [self.integerAmountLabel setText:@"-￥0.00"];
    }
    
    [self.givingAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCCustomOrderDetailList instance].orderInfo.donationAmount]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
