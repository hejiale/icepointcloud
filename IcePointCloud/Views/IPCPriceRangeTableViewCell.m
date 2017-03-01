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
    
    self.startPriceTextField.layer.cornerRadius = 12;
    self.endPriceTextField.layer.cornerRadius = 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
