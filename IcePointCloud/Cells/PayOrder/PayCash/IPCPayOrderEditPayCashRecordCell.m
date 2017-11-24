//
//  IPCPayOrderEditPayCashRecordCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderEditPayCashRecordCell.h"

@implementation IPCPayOrderEditPayCashRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.payAmountTextField addBottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setPayRecord:(IPCPayRecord *)payRecord{
    _payRecord = payRecord;
    
    if (_payRecord) {
        [self.payTypeLabel setText:[NSString stringWithFormat:@"%@支付",_payRecord.payTypeInfo]];
        [self.dateLabel setText:[NSDate jk_stringWithDate:_payRecord.payDate format:@"yyyy-MM-dd"]];
    }
}


- (IBAction)cancelAddRecordAction:(id)sender {
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    double pointPrice =  ([textField.text doubleValue] * [IPCPayOrderManager sharedManager].integralTrade.money)/[IPCPayOrderManager sharedManager].integralTrade.integral;
    
    if ([self.payRecord.payTypeInfo isEqualToString:@"积分"]) {
        self.payRecord.pointPrice = pointPrice;
        self.payRecord.integral = [textField.text integerValue];
    }else{
        self.payRecord.payPrice = [textField.text doubleValue];
    }
    self.payRecord.isEditStatus = NO;
    
    if ([self.delegate respondsToSelector:@selector(reloadRecord:)]) {
        [self.delegate reloadRecord:self];
    }
}


@end
