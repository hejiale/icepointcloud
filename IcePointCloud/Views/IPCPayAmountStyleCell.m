//
//  IPCPayAmountStyleCell.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayAmountStyleCell.h"

@interface IPCPayAmountStyleCell()

@property (copy, nonatomic) void(^UpdateOrderBlock)();

@end

@implementation IPCPayAmountStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.prePayAmountTextField addBorder:5 Width:0.7];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateUI:(void(^)())update
{
    self.UpdateOrderBlock = update;
    
    [self.payAmountButton setSelected:NO];
    [self.prePayAmountButton setSelected:NO];
    
    switch ([IPCPayOrderMode sharedManager].payType) {
        case IPCOrderPayTypePayAmount:
            [self.payAmountButton setSelected:YES];
            break;
        case IPCOrderPayTypeInstallment:
            [self.prePayAmountButton setSelected:YES];
            break;
        default:
            break;
    }
    
    if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye) {
        if ([IPCPayOrderMode sharedManager].employeAmount > 0 && [IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount)
        {
            [self.amountLabel setText:[NSString stringWithFormat:@"￥%.f",[IPCPayOrderMode sharedManager].employeAmount]];
        }
    }else{
        [self.amountLabel setText:[NSString stringWithFormat:@"￥%.f",[[IPCShoppingCart sharedCart] selectedNormalSellGlassesTotalPrice]]];
    }
    
    if ([IPCPayOrderMode sharedManager].prepaidAmount > 0){
        [self.prePayAmountTextField setText:[NSString stringWithFormat:@"%.f",[IPCPayOrderMode sharedManager].prepaidAmount]];
    }else{
        [self.prePayAmountTextField setText:@""];
    }
}


#pragma mark //Clicked Events
- (IBAction)payAmountAction:(UIButton *)sender {
    if (! sender.selected) {
        [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypePayAmount;
        
        if (self.UpdateOrderBlock)
            self.UpdateOrderBlock();
    }
}

- (IBAction)payPreAmountAction:(UIButton *)sender {
    if (! sender.selected) {
        [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypeInstallment;
        
        if (self.UpdateOrderBlock)
            self.UpdateOrderBlock();
    }
}

#pragma mark //UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (! [IPCPayOrderMode sharedManager].currentEmploye) {
        [IPCCustomUI showError:@"请先选择员工号"];
        [textField resignFirstResponder];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsNumber:string])
        return NO;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length && [textField.text doubleValue] > 0){
        if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye) {
            if ([textField.text doubleValue] > [IPCPayOrderMode sharedManager].employeAmount){
                [IPCCustomUI showError:@"输入的金额大于打折金额!"];
            }else{
                [IPCPayOrderMode sharedManager].prepaidAmount = [textField.text doubleValue];
            }
        }else{
            if ([textField.text doubleValue] > [[IPCShoppingCart sharedCart] selectedNormalSellGlassesTotalPrice]){
                [IPCCustomUI showError:@"输入的金额大于订单总价!"];
            }else{
                [IPCPayOrderMode sharedManager].prepaidAmount = [textField.text doubleValue];
            }
        }
        if (self.UpdateOrderBlock)
            self.UpdateOrderBlock();
    }else{
        [textField setText:@""];
    }
}


@end
