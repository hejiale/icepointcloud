//
//  PriceRangeTableViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPriceRangeTableViewCell.h"

@implementation IPCPriceRangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.completeButton.layer.cornerRadius = 20;
    [self.completeButton setBackgroundColor:COLOR_RGB_BLUE];
    self.startPriceTextField.layer.cornerRadius = 15;
    self.endPriceTextField.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)searchProductAction:(id)sender {
    NSString * startPrice = [self.startPriceTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * endPrice = [self.endPriceTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([startPrice doubleValue] < 0)startPrice = 0;
    if ([endPrice doubleValue] < 0)endPrice = 0;
    
    if ([endPrice doubleValue] > 0) {
        if ([startPrice doubleValue] > [endPrice doubleValue]) {
            [IPCUIKit showError:@"输入起始金额有误!"];
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(reloadPriceRangProducts:EndPrice:)]) {
        [self.delegate reloadPriceRangProducts:[startPrice doubleValue] EndPrice:[endPrice doubleValue]];
    }
}

#pragma mark //UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(![IPCCommon judgeIsNumber:string])
        return NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
