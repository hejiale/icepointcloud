//
//  HistoryOrderCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCHistoryOrderCell.h"

@implementation IPCHistoryOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomerOrder:(IPCCustomerOrderMode *)customerOrder{
    _customerOrder = customerOrder;
    
    if (_customerOrder) {
        [self.orderCodeLabel setText:[NSString stringWithFormat:@"订单编号: %@",_customerOrder.orderCode]];
        
        NSString * pirce = [NSString stringWithFormat:@"订单价格: ￥%.2f",_customerOrder.orderPrice];
        
        [self.orderPriceLabel setAttributedText:[IPCUIKit subStringWithText:pirce BeginRang:7 Rang:pirce.length - 7 Font:[UIFont systemFontOfSize:16 weight:UIFontWeightThin] Color:[UIColor darkGrayColor]]];
        
        
        [self.orderDateLabel setText:[NSString stringWithFormat:@"下单时间: %@",[IPCCommon formatDate:[IPCCommon dateFromString:_customerOrder.orderDate] IsTime:YES]]];
        
        [self.orderStatusLabel setText:[IPCAppManager orderStatus:_customerOrder.orderStatus]];
        [self.orderStatusLabel setTextColor:[UIColor jk_colorWithHexString:@"#ff9900"]];
    }
}


@end
