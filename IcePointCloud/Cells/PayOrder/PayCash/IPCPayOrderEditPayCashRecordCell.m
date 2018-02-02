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
        _payAmountTextField.rightSpace = 5;
        _payAmountTextField.textAlignment = NSTextAlignmentRight;
    }
    return _payAmountTextField;
}

- (void)setPayRecord:(IPCPayRecord *)payRecord{
    _payRecord = payRecord;
    
    if (_payRecord) {
        [self.payTypeLabel setText:[NSString stringWithFormat:@"%@支付",_payRecord.payOrderType.payType]];
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
    NSString * remainPriceStr = [NSString stringWithFormat:@"%f", [[IPCPayOrderManager sharedManager] remainPayPrice]];
    NSString * balanceStr = [NSString stringWithFormat:@"%f", [[IPCPayOrderCurrentCustomer sharedManager].currentCustomer useBalance]];
    NSString * integralStr = [NSString stringWithFormat:@"%d", [[IPCPayOrderCurrentCustomer sharedManager].currentCustomer userIntegral]];
    
    if (textField.text.length) {
        if ([self.payRecord.payOrderType.payType isEqualToString:@"积分"])
        {
            double pointPrice =  ([textField.text doubleValue] * [IPCPayOrderManager sharedManager].integralTrade.money)/[IPCPayOrderManager sharedManager].integralTrade.integral;
            NSString * pointPriceStr = [NSString stringWithFormat:@"%f", pointPrice];
            
            if ([IPCCommon afterDouble:remainPriceStr : pointPriceStr] < 0) {
                [IPCCommonUI showError:@"输入积分兑换金额大于剩余应付金额"];
            }else if ([IPCCommon afterDouble:integralStr :textField.text] < 0){
                [IPCCommonUI showError:@"输入积分大于客户积分"];
            } else if (pointPrice <= 0){
                [IPCCommonUI showError:@"请输入有效积分"];
            }else{
                self.payRecord.pointPrice = pointPrice;
                self.payRecord.integral = [textField.text integerValue];
                [[IPCPayOrderManager sharedManager].payTypeRecordArray addObject:self.payRecord];
            }
        }else if ([self.payRecord.payOrderType.payType isEqualToString:@"储值卡"]){
            if ([IPCCommon afterDouble:balanceStr :textField.text] < 0){
                [IPCCommonUI showError:@"输入金额大于客户储值余额"];
            }else if ([IPCCommon afterDouble:remainPriceStr :textField.text] < 0){
                [IPCCommonUI showError:@"输入有效付款金额"];
            }else{
                self.payRecord.payPrice = [textField.text doubleValue];
                [[IPCPayOrderManager sharedManager].payTypeRecordArray addObject:self.payRecord];
            }
        }else{
            if ([IPCCommon afterDouble:remainPriceStr :textField.text] >= 0) {
                self.payRecord.payPrice = [textField.text doubleValue];
                [[IPCPayOrderManager sharedManager].payTypeRecordArray addObject:self.payRecord];
            } else{
                [IPCCommonUI showError:@"输入有效付款金额"];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(reloadRecord:)]) {
        [self.delegate reloadRecord:self];
    }
}


@end
