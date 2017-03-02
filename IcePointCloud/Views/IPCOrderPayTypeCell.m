//
//  IPCOrderPayTypeCell.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderPayTypeCell.h"

typedef void(^PopEmployeBlock)();
typedef void(^UpdateBlock)();

@interface IPCOrderPayTypeCell()

@property (nonatomic, copy) PopEmployeBlock employeBlock;
@property (nonatomic, copy) UpdateBlock  updateBlock;

@end

@implementation IPCOrderPayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.employeSwitch setOnTintColor:COLOR_RGB_BLUE];
    [IPCUIKit textFieldRightButton:self Action:@selector(showEmployeAction) InTextField:self.employeTextField OnView:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUI:(void(^)())employe Update:(void (^)())update
{
    self.employeBlock = employe;
    self.updateBlock = update;
    
//    switch ([IPCPayOrderMode sharedManager].payType) {
//        case IPCOrderPayTypePayAmount:
//            [self.payAmountButton setSelected:YES];
//            break;
//        case IPCOrderPayTypeInstallment:
//            [self.installmentButton setSelected:YES];
//            break;
//        default:
//            break;
//    }

//    if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye) {
//        if ([IPCPayOrderMode sharedManager].employeAmount > 0) {
//            [self.amountLabel setText:[NSString stringWithFormat:@"￥%.f",[IPCPayOrderMode sharedManager].employeAmount]];
//        }
//    }else{
//        [self.amountLabel setText:[NSString stringWithFormat:@"￥%.f",[[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]]];
//    }
    
//    if ([IPCPayOrderMode sharedManager].employeAmount > 0) {
//        [self.discountTextField setText:[NSString stringWithFormat:@"%.f",[IPCPayOrderMode sharedManager].employeAmount]];
//    }else{
//        [self.discountTextField setText:@""];
//    }
    
//    if ([IPCPayOrderMode sharedManager].prepaidAmount > 0){
//        [self.installmentTextField setText:[NSString stringWithFormat:@"%.f",[IPCPayOrderMode sharedManager].prepaidAmount]];
//    }else{
//        [self.installmentTextField setText:@""];
//    }
    
    if ([IPCPayOrderMode sharedManager].currentEmploye) {
        [self.employeTextField setText:[NSString stringWithFormat:@"员工号:%@/员工名:%@",[IPCPayOrderMode sharedManager].currentEmploye.jobNumber,[IPCPayOrderMode sharedManager].currentEmploye.name]];
    }
    
    [self.employeSwitch setSelected:[IPCPayOrderMode sharedManager].isSelectEmploye];
//    [self.employeBgView setHidden:![IPCPayOrderMode sharedManager].isSelectEmploye];
}

#pragma mark //Clicked Events
//- (IBAction)payAmountAction:(id)sender {
//    [self.installmentButton setSelected:NO];
//
//    if (! self.payAmountButton.selected) {
//        [self.payAmountButton setSelected:!self.payAmountButton.selected];
//        [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypePayAmount;
//        
//        if (self.updateBlock)
//            self.updateBlock();
//    }
//}
//
//- (IBAction)installmentAmountAction:(id)sender {
//    [self.payAmountButton setSelected:NO];
//    
//    if (! self.installmentButton.selected) {
//        [self.installmentButton setSelected:!self.installmentButton.selected];
//        [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypeInstallment;
//        
//        if (self.updateBlock)
//            self.updateBlock();
//    }
//}


- (IBAction)selectEmployeAction:(UISwitch *)sender {
    if ([IPCPayOrderMode sharedManager].currentEmploye) {
        [IPCPayOrderMode sharedManager].isSelectEmploye = sender.isOn;
        if (self.updateBlock)
            self.updateBlock();
    }else{
        [sender setOn:NO animated:NO];
        [IPCUIKit showError:@"请先选择员工号"];
    }
}


- (void)showEmployeAction{
    if (self.employeBlock) {
        self.employeBlock();
    }
}

#pragma mark //UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (! [IPCPayOrderMode sharedManager].currentEmploye) {
        [IPCUIKit showError:@"请先选择员工号"];
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
//        if ([textField isEqual:self.installmentTextField]) {
//            if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye) {
//                if ([textField.text doubleValue] > [IPCPayOrderMode sharedManager].employeAmount){
//                    [IPCUIKit showError:@"输入的金额大于打折金额!"];
//                }else{
//                    [IPCPayOrderMode sharedManager].prepaidAmount = [textField.text doubleValue];
//                }
//            }else{
//                if ([textField.text doubleValue] > [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]){
//                    [IPCUIKit showError:@"输入的金额大于订单总价!"];
//                }else{
//                    [IPCPayOrderMode sharedManager].prepaidAmount = [textField.text doubleValue];
//                }
//            }
//        }else{
            if ([IPCPayOrderMode sharedManager].currentEmploye) {
                double discountAmount = [IPCPayOrderMode sharedManager].discountAmount;
                
                if ([textField.text doubleValue] < discountAmount){
                    [IPCUIKit showError:@"输入的打折金额小于最低折扣!"];
                }else if ([textField.text doubleValue] > [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]){
                    [IPCUIKit showError:@"输入打折金额大于订单总价!"];
                }else if ([textField.text doubleValue] < [IPCPayOrderMode sharedManager].prepaidAmount){
                    [IPCUIKit showError:@"输入的打折金额小于预付款金额!"];
                }else{
                    [IPCPayOrderMode sharedManager].employeAmount = [textField.text doubleValue];
                }
            }
//        }
        if (self.updateBlock)
            self.updateBlock();
    }else{
        [textField setText:@""];
    }
}


@end
