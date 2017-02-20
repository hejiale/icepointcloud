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


- (void)inputOrderInfo:(IPCCustomerOrderInfo *)orderInfo{
    [self.orderCodeLabel setText:orderInfo.orderNumber];
    [self.createDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:orderInfo.orderTime]  IsTime:YES]];
    [self.operationLabel setText:orderInfo.operatorName];
}

@end
