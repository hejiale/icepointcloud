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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.orderCodeLabel setText:[IPCCustomerOrderDetail instance].orderInfo.orderNumber];
    [self.createDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:[IPCCustomerOrderDetail instance].orderInfo.orderTime]  IsTime:YES]];
    [self.operationLabel setText:[IPCCustomerOrderDetail instance].orderInfo.operatorName];
    NSString * remark = [NSString stringWithFormat:@"本次消费产生积分%d",[IPCCustomerOrderDetail instance].orderInfo.integral];
    [self.pointLabel setAttributedText:[IPCCustomUI subStringWithText:remark BeginRang:8 Rang:remark.length - 8 Font:self.pointLabel.font Color:COLOR_RGB_RED]];
}


@end
