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
    [self.payAmountTextField addBorder:3 Width:0.5];
    [self.payAmountTextField setRightSpace:5];
    [self.payAmountTextField setLeftText:@"￥"];
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
    if ([IPCPayOrderMode sharedManager].isTrade) {
        [self.selectPointButton setHidden:NO];
        self.selectPointButtonWidth.constant = 40;
        [self.pointAmountTextField addBorder:3 Width:0.5];
    }else{
        [self.selectPointButton setHidden:YES];
        self.selectPointButtonWidth.constant = 0;
        [self.pointAmountTextField addBorder:0 Width:0];
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
    [self.pointAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCPayOrderMode sharedManager].pointPrice]];
    
    if ([IPCPayOrderMode sharedManager].realTotalPrice > 0) {
        [self.payAmountTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderMode sharedManager].realTotalPrice]];
    }else{
        [self.payAmountTextField setText:@""];
    }

    [self.pointAmountTextField setText:[NSString stringWithFormat:@"%d",[IPCPayOrderMode sharedManager].usedPoint]];
    [self.customerPointLabel setText:[NSString stringWithFormat:@"%d点积分可用",[IPCPayOrderMode sharedManager].point]];
    [self.givingAmountLabel setText:[NSString stringWithFormat:@"赠送金额 ￥%.2f",[IPCPayOrderMode sharedManager].givingAmount]];
}

#pragma mark //Clicke Events
//选择积分抵扣
- (IBAction)selectPayPointAction:(UIButton *)sender {
    if ([[IPCShoppingCart sharedCart] isHaveUsedPoint])return;
    
    [sender setSelected:!sender.selected];
    [IPCPayOrderMode sharedManager].isSelectPoint = sender.selected;
    if (!sender.selected) {
        [IPCPayOrderMode sharedManager].realTotalPrice    += [IPCPayOrderMode sharedManager].pointPrice;// 刷新实际价格
        [IPCPayOrderMode sharedManager].remainAmount  += [IPCPayOrderMode sharedManager].pointPrice;//刷新剩余付款金额
        [[IPCPayOrderMode sharedManager].payTypeRecordArray removeAllObjects];
        [IPCPayOrderMode sharedManager].usedPoint = 0;
        [IPCPayOrderMode sharedManager].pointPrice = 0;
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

#pragma mark //UITextFidle Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.pointAmountTextField]) {
        if (![IPCCommon judgeIsIntNumber:string]) {
            return NO;
        }
    }else{
        if (![IPCCommon judgeIsFloatNumber:string]) {
            return NO;
        }
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([textField isEqual:self.pointAmountTextField]) {
            //获取积分换取金额
            if ([str integerValue] > [IPCPayOrderMode sharedManager].point) {
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(getPointPrice:)]) {
                        [self.delegate getPointPrice:[IPCPayOrderMode sharedManager].point];
                    }
                }
            }else{
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(getPointPrice:)]) {
                        [self.delegate getPointPrice:[str integerValue]];
                    }
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
            //剩余支付金额
            [IPCPayOrderMode sharedManager].remainAmount = [IPCPayOrderMode sharedManager].realTotalPrice;
            [[IPCPayOrderMode sharedManager].payTypeRecordArray removeAllObjects];
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}



@end
