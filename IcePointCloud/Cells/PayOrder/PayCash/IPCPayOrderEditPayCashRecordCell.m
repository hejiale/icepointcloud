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
    
    [self.payAmountView addBottomLine];
    [self.payAmountView addSubview:self.payAmountTextField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IPCCustomKeyboard *)payAmountTextField
{
    if (!_payAmountTextField) {
        _payAmountTextField = [[IPCCustomTextField alloc]initWithFrame:self.payAmountView.bounds];
        [_payAmountTextField setDelegate:self];
        _payAmountTextField.textAlignment = NSTextAlignmentRight;
    }
    return _payAmountTextField;
}

- (void)setPayRecord:(IPCPayRecord *)payRecord{
    _payRecord = payRecord;
    
    if (_payRecord) {
        [self.payTypeLabel setText:[NSString stringWithFormat:@"%@支付",_payRecord.payTypeInfo]];
        [self.dateLabel setText:[NSDate jk_stringWithDate:_payRecord.payDate format:@"yyyy-MM-dd"]];
        [self.payAmountTextField setText:@""];
        [self.payAmountTextField setIsEditing:YES];
    }
}

#pragma mark //Clicked Events
- (IBAction)cancelAddRecordAction:(id)sender {
}

#pragma mark //UITextFieldDelegate
- (void)textFieldEndEditing:(IPCCustomTextField *)textField
{
    BOOL isInsert = NO;
    
    if (textField.text.length) {
        if ([self.payRecord.payTypeInfo isEqualToString:@"积分"])
        {
            double pointPrice =  ([textField.text doubleValue] * [IPCPayOrderManager sharedManager].integralTrade.money)/[IPCPayOrderManager sharedManager].integralTrade.integral;
            if (pointPrice > [[IPCPayOrderManager sharedManager] remainPayPrice]) {
                [IPCCommonUI showError:@"输入积分兑换金额大于剩余应付金额"];
            }else if ([textField.text integerValue] > [IPCPayOrderCurrentCustomer sharedManager].currentCustomer.integral){
                [IPCCommonUI showError:@"输入积分大于客户积分"];
            } else if (pointPrice <= 0){
                [IPCCommonUI showError:@"请输入有效积分"];
            }else{
                self.payRecord.pointPrice = pointPrice;
                self.payRecord.integral = [textField.text integerValue];
                [[IPCPayOrderManager sharedManager].payTypeRecordArray addObject:self.payRecord];
                isInsert = YES;
            }
        }else if ([self.payRecord.payTypeInfo isEqualToString:@"储值卡"]){
            if ([textField.text doubleValue] > [IPCPayOrderCurrentCustomer sharedManager].currentCustomer.balance){
                [IPCCommonUI showError:@"输入金额大于客户储值余额"];
            }else if ([textField.text doubleValue] <= [[IPCPayOrderManager sharedManager] remainPayPrice] && [textField.text doubleValue] > 0){
                self.payRecord.payPrice = [textField.text doubleValue];
                [[IPCPayOrderManager sharedManager].payTypeRecordArray addObject:self.payRecord];
                isInsert = YES;
            }else{
                [IPCCommonUI showError:@"输入有效付款金额"];
            }
        }else{
            if ([textField.text doubleValue] <= [[IPCPayOrderManager sharedManager] remainPayPrice] && [textField.text doubleValue] > 0) {
                self.payRecord.payPrice = [textField.text doubleValue];
                [[IPCPayOrderManager sharedManager].payTypeRecordArray addObject:self.payRecord];
                isInsert = YES;
            }else{
                [IPCCommonUI showError:@"输入有效付款金额"];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(reloadRecord:IsInsert:)]) {
        [self.delegate reloadRecord:self IsInsert:isInsert];
    }
}


@end
