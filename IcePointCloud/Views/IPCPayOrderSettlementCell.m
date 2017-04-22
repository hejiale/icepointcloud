//
//  IPCPayOrderSettlementCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderSettlementCell.h"

@implementation IPCPayOrderSettlementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.totalPriceLabel setTextColor:COLOR_RGB_RED];
    [self.pointAmountLabel setTextColor:COLOR_RGB_RED];
    [self.pointAmountTextField addBorder:3 Width:0.5];
    [self.payAmountTextField addBorder:3 Width:0.5];
    [self.depositTextField addBorder:3 Width:0.5];
    [self.depositTextField setRightSpace:5];
    [self.payAmountTextField setRightSpace:5];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self updateUI];
    
}

- (void)updateUI
{
    [self.fullAmountButton setSelected:NO];
    [self.depositButton setSelected:NO];
    if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount) {
        [self.fullAmountButton setSelected:YES];
    }else{
        [self.depositButton setSelected:YES];
    }
    
    if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount) {
        [self.depositTextField setEnabled:NO];
    }else{
        [self.depositTextField setEnabled:YES];
    }
    
    if ([[IPCShoppingCart sharedCart] isHaveUsedPoint]) {
        [self.pointAmountTextField setEnabled:NO];
        [self.selectPointButton setEnabled:YES];
        [self.selectPointButton setSelected:YES];
    }else{
        if ([IPCPayOrderMode sharedManager].isSelectPoint) {
            [self.selectPointButton setSelected:YES];
        }else{
            [self.selectPointButton setSelected:NO];
        }
        
        if ([IPCPayOrderMode sharedManager].point >  0) {
            [self.selectPointButton setEnabled:YES];
            if ([IPCPayOrderMode sharedManager].isSelectPoint) {
                [self.pointAmountTextField setEnabled:YES];
            }else{
                [self.pointAmountTextField setEnabled:NO];
            }
        }else{
            [self.selectPointButton setEnabled:NO];
            [self.pointAmountTextField setEnabled:NO];
        }
    }

    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCShoppingCart sharedCart] selectedPayItemTotalPrice]]];
    [self.pointAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[IPCPayOrderMode sharedManager].pointPrice]];
    [self.payAmountTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderMode sharedManager].realTotalPrice]];
    [self.depositTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderMode sharedManager].presellAmount]];
    [self.pointAmountTextField setText:[NSString stringWithFormat:@"%.f",[IPCPayOrderMode sharedManager].usedPoint]];
    [self.customerPointLabel setText:[NSString stringWithFormat:@"%.f点积分可用",[IPCPayOrderMode sharedManager].point]];
    [self.givingAmountLabel setText:[NSString stringWithFormat:@"赠送金额 ￥%.2f",[IPCPayOrderMode sharedManager].givingAmount]];
}

#pragma mark //Clicke Events
//选择积分抵扣
- (IBAction)selectPayPointAction:(UIButton *)sender {
    if ([[IPCShoppingCart sharedCart] isHaveUsedPoint])return;
    
    [sender setSelected:!sender.selected];
    [IPCPayOrderMode sharedManager].isSelectPoint = sender.selected;
    if (!sender.selected) {
        [IPCPayOrderMode sharedManager].realTotalPrice += [IPCPayOrderMode sharedManager].pointPrice;// 刷新实际价格
        [IPCPayOrderMode sharedManager].usedPoint = 0;
        [IPCPayOrderMode sharedManager].pointPrice = 0;
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

//选择全额支付
- (IBAction)selectFullAmountAction:(UIButton *)sender {
    [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypePayAmount;
    [IPCPayOrderMode sharedManager].presellAmount = 0;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}


- (IBAction)selectPayPresellAmountAction:(UIButton *)sender {
    [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypeInstallment;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

#pragma mark //UITextFidle Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([textField isEqual:self.pointAmountTextField]) {
            //获取积分换取金额
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(getPointPrice:)]) {
                    [self.delegate getPointPrice:[str doubleValue]];
                }
            }
        }else if ([textField isEqual:self.payAmountTextField]){
            //判断实际输入价格
            if (([[IPCShoppingCart sharedCart] selectedPayItemTotalPrice] - [IPCPayOrderMode sharedManager].pointPrice) < [str doubleValue]) {
                [IPCPayOrderMode sharedManager].realTotalPrice = [[IPCShoppingCart sharedCart] selectedPayItemTotalPrice] - [IPCPayOrderMode sharedManager].pointPrice;
            }else{
                [IPCPayOrderMode sharedManager].realTotalPrice = [str doubleValue];
            }
            //计算赠送金额
            [IPCPayOrderMode sharedManager].givingAmount = [[IPCShoppingCart sharedCart] selectedPayItemTotalPrice] - [IPCPayOrderMode sharedManager].pointPrice - [IPCPayOrderMode sharedManager].realTotalPrice;
            if ([IPCPayOrderMode sharedManager].givingAmount <= 0) {
                [IPCPayOrderMode sharedManager].givingAmount = 0;
            }
            [IPCPayOrderMode sharedManager].presellAmount = 0;
        }else if ([textField isEqual:self.depositTextField]){
            if ([IPCPayOrderMode sharedManager].realTotalPrice > 0) {
                if ([IPCPayOrderMode sharedManager].realTotalPrice < [str doubleValue]) {
                    [IPCPayOrderMode sharedManager].presellAmount = [IPCPayOrderMode sharedManager].realTotalPrice;
                }else{
                    [IPCPayOrderMode sharedManager].presellAmount = [str doubleValue];
                }
            }else{
                if ([[IPCShoppingCart sharedCart] selectedPayItemTotalPrice] < [str doubleValue]) {
                    [IPCPayOrderMode sharedManager].presellAmount = [[IPCShoppingCart sharedCart] selectedPayItemTotalPrice];
                }else{
                    [IPCPayOrderMode sharedManager].presellAmount = [str doubleValue];
                }
            }
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}



@end
