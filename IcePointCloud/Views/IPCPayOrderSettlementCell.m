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
    
    [self.pointAmountTextField addBorder:0 Width:1];
    [self.givingAmountTextField addBorder:0 Width:1];
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
    [self.pointView setHidden:![IPCPayOrderManager sharedManager].isTrade];
    
    if ([IPCPayOrderManager sharedManager].isTrade) {
        self.pointHeight.constant = 50;
        self.leftGivingConstraint.constant = 45;
    }else{
        self.pointHeight.constant = 0;
        self.leftGivingConstraint.constant = 20;
    }
    
    if ([IPCPayOrderManager sharedManager].point == 0) {
        [self.selectPointButton setSelected:NO];
    }else{
        [self.selectPointButton setSelected:([IPCPayOrderManager sharedManager].isSelectPoint)];
    }
    
    [self.selectPointButton setUserInteractionEnabled:([IPCPayOrderManager sharedManager].point >  0)];
    [self.pointAmountTextField setEnabled:([IPCPayOrderManager sharedManager].isSelectPoint)];
    
    if ([IPCPayOrderManager sharedManager].point >  0) {
        [self.pointView setAlpha:1];
    }else{
        [self.pointView setAlpha:0.5];
    }
    
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCShoppingCart sharedCart] allGlassesTotalPrice]]];
    [self.pointAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCPayOrderManager sharedManager].pointPrice]];
    [self.givingAmountTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderManager sharedManager].givingAmount]];
    [self.givingAmountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[IPCPayOrderManager sharedManager].givingAmount]];
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
            [[IPCPayOrderManager sharedManager] resetPayPrice];
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
            
            if ([IPCShoppingCart sharedCart].allGlassesTotalPrice - [IPCPayOrderManager sharedManager].pointPrice<= [str doubleValue]) {
                [IPCPayOrderManager sharedManager].givingAmount = [IPCShoppingCart sharedCart].allGlassesTotalPrice - [IPCPayOrderManager sharedManager].pointPrice;
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
