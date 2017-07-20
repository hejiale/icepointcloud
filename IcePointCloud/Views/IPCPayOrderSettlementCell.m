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
    //    if ([IPCPayOrderManager sharedManager].isTrade) {
    //        [self.selectPointButton setHidden:NO];
    //    }else{
    //        [self.selectPointButton setHidden:YES];
    //    }
    
    if ([[IPCShoppingCart sharedCart] isHaveUsedPoint]) {
        [self.pointAmountTextField setEnabled:NO];
        [self.selectPointButton setEnabled:YES];
        [self.selectPointButton setSelected:YES];
    }else{
        if ([IPCPayOrderManager sharedManager].isSelectPoint) {
            [self.selectPointButton setSelected:YES];
        }else{
            [self.selectPointButton setSelected:NO];
        }
        
        if ([IPCPayOrderManager sharedManager].point >  0) {
            [self.selectPointButton setEnabled:YES];
            if ([IPCPayOrderManager sharedManager].isSelectPoint) {
                [self.pointAmountTextField setEnabled:YES];
            }else{
                [self.pointAmountTextField setEnabled:NO];
            }
        }else{
            [self.selectPointButton setEnabled:NO];
            [self.pointAmountTextField setEnabled:NO];
        }
    }
    
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]]];
    [self.pointAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCPayOrderManager sharedManager].pointPrice]];
    [self.payAmountTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderManager sharedManager].realTotalPrice]];
    [self.pointAmountTextField setText:[NSString stringWithFormat:@"%d",[IPCPayOrderManager sharedManager].usedPoint]];
}

#pragma mark //Clicke Events
//选择积分抵扣
- (IBAction)selectPayPointAction:(UIButton *)sender {
    if ([[IPCShoppingCart sharedCart] isHaveUsedPoint])return;
    
    [IPCPayOrderManager sharedManager].isSelectPoint = !sender.selected;
    
    if (!sender.selected) {
        [IPCPayOrderManager sharedManager].realTotalPrice    += [IPCPayOrderManager sharedManager].pointPrice;// 刷新实际价格
        [IPCPayOrderManager sharedManager].remainAmount  += [IPCPayOrderManager sharedManager].pointPrice;//刷新剩余付款金额
        [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
        [IPCPayOrderManager sharedManager].point += [IPCPayOrderManager sharedManager].usedPoint;
        [IPCPayOrderManager sharedManager].usedPoint = 0;
        [IPCPayOrderManager sharedManager].pointPrice = 0;
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
            if ([str integerValue] > [IPCPayOrderManager sharedManager].point) {
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(getPointPrice:)]) {
                        [self.delegate getPointPrice:[IPCPayOrderManager sharedManager].point];
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
            if (([[IPCShoppingCart sharedCart] selectedGlassesTotalPrice] - [IPCPayOrderManager sharedManager].pointPrice) < [str doubleValue]) {
                [IPCPayOrderManager sharedManager].realTotalPrice = [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice] - [IPCPayOrderManager sharedManager].pointPrice;
            }else{
                [IPCPayOrderManager sharedManager].realTotalPrice = [str doubleValue];
            }
            //计算赠送金额
            [IPCPayOrderManager sharedManager].givingAmount = [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice] - [IPCPayOrderManager sharedManager].pointPrice - [IPCPayOrderManager sharedManager].realTotalPrice;
            if ([IPCPayOrderManager sharedManager].givingAmount <= 0) {
                [IPCPayOrderManager sharedManager].givingAmount = 0;
            }
            //剩余支付金额
            [IPCPayOrderManager sharedManager].remainAmount = [IPCPayOrderManager sharedManager].realTotalPrice;
            [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}



@end
