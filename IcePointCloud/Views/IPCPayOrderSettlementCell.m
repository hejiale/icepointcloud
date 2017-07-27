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
    
    [self.givingAmountTextField setLeftText:@"￥"];
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
    if ([IPCPayOrderManager sharedManager].isTrade) {
        [self.pointView setHidden:NO];
        self.pointHeight.constant = 95;
    }else{
        [self.pointView setHidden:YES];
        self.pointHeight.constant = 0;
    }
    
    [self.selectPointButton setSelected:[IPCPayOrderManager sharedManager].isSelectPoint];
    
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
    
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCShoppingCart sharedCart] allGlassesTotalPrice]]];
    [self.pointAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCPayOrderManager sharedManager].pointPrice]];
    [self.givingAmountTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderManager sharedManager].givingAmount]];
    [self.pointAmountTextField setText:[NSString stringWithFormat:@"%d",[IPCPayOrderManager sharedManager].usedPoint]];
    [self.countLabel setText:[NSString stringWithFormat:@"%d件",[[IPCShoppingCart sharedCart] allGlassesCount]]];
    [self.payAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCPayOrderManager sharedManager] realTotalPrice]]];
}

#pragma mark //Clicke Events
//选择积分抵扣
- (IBAction)selectPayPointAction:(UIButton *)sender {
    [IPCPayOrderManager sharedManager].isSelectPoint = !sender.selected;
    
    if (![IPCPayOrderManager sharedManager].isSelectPoint) {
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
            [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
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
        }else if ([textField isEqual:self.givingAmountTextField]){
            [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
            
            if ([[IPCPayOrderManager sharedManager] realTotalPrice] <= [str doubleValue]) {
                [IPCPayOrderManager sharedManager].givingAmount = [[IPCPayOrderManager sharedManager] realTotalPrice];
            }else{
                [IPCPayOrderManager sharedManager].givingAmount = [str doubleValue];
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
