//
//  PersonInputCell.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPersonInputCell.h"

@implementation IPCPersonInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [IPCCommonUI clearAutoCorrection:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
