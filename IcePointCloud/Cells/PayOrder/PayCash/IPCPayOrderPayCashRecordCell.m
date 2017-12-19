//
//  IPCPayOrderPayCashRecordCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderPayCashRecordCell.h"

@implementation IPCPayOrderPayCashRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPayRecord:(IPCPayRecord *)payRecord{
    _payRecord = payRecord;
    
    if (_payRecord) {
        [self.payTypeNameLabel setText:[NSString stringWithFormat:@"%@支付",_payRecord.payOrderType.payType]];
        
        [self.createDateLabel setText:[NSDate jk_stringWithDate:_payRecord.payDate format:@"yyyy-MM-dd"]];
        
        if ([_payRecord.payOrderType.payType isEqualToString:@"积分"]) {
            [self.payTypeAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",_payRecord.pointPrice]];
            [self.pointLabel setText:[NSString stringWithFormat:@"%d积分",_payRecord.integral]];
        }else{
            [self.payTypeAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",_payRecord.payPrice]];
        }
    }
}

#pragma mark //Clicked Events
- (IBAction)removePayRecordAction:(id)sender {
}

@end
