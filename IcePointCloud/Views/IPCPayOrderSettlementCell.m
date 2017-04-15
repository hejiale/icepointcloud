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
    [self.pointAmountTextField addBorder:3 Width:1];
    [self.payAmountTextField addBorder:3 Width:1];
    [self.depositTextField addBorder:3 Width:1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUI
{
    [self.fullAmountButton setSelected:NO];
    [self.depositButton setSelected:NO];
    
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.f",[IPCPayOrderMode sharedManager].orderTotalPrice]];
    [self.pointAmountLabel setText:[NSString stringWithFormat:@"￥%.f",[IPCPayOrderMode sharedManager].pointPrice]];
    [self.payAmountTextField setText:[NSString stringWithFormat:@"￥%.f",[IPCPayOrderMode sharedManager].realTotalPrice]];
    [self.depositTextField setText:[NSString stringWithFormat:@"￥%.f",[IPCPayOrderMode sharedManager].presellAmount]];
    [self.pointAmountTextField setText:[NSString stringWithFormat:@"%.f",[IPCPayOrderMode sharedManager].point]];
    [self.customerPointLabel setText:[NSString stringWithFormat:@"客户可用积分(%.f)",[IPCCurrentCustomerOpometry sharedManager].currentCustomer.integral]];
    if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount) {
        [self.fullAmountButton setSelected:YES];
    }else{
        [self.depositButton setSelected:YES];
    }
}

#pragma mark //Clicke Events
//选择积分抵扣
- (IBAction)selectPayPointAction:(id)sender {
    
}

//选择全额支付
- (IBAction)selectFullAmountAction:(id)sender {
    
}


- (IBAction)selectPayPresellAmountAction:(id)sender {
    
}

#pragma mark //UITextFidle Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}



@end
