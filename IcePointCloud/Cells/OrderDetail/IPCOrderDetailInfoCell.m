//
//  OrderDetailInfoTableViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderDetailInfoCell.h"

@implementation IPCOrderDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setOrderInfo:(IPCCustomerOrderInfo *)orderInfo
{
    _orderInfo = orderInfo;
    
    if (_orderInfo) {
        [self.orderCodeLabel setText:_orderInfo.orderNumber];
        [self.createDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:_orderInfo.orderTime]  IsTime:YES]];
        [self.operationLabel setText:_orderInfo.employee.name];
        NSString * remark = [NSString stringWithFormat:@"本次消费产生积分%d",_orderInfo.integralGiven];
        [self.pointLabel subStringWithText:remark BeginRang:8 Font:self.pointLabel.font Color:COLOR_RGB_RED];
    }
}


@end
