//
//  OrderDetailMemoCell.m
//  IcePointCloud
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderDetailMemoCell.h"

@implementation IPCOrderDetailMemoCell

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
    
    [self.memoLabel setText:[IPCCustomerOrderDetail instance].orderInfo.remark];
}

@end
