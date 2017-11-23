//
//  PersonHeadCell.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPersonHeadCell.h"

@implementation IPCPersonHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if ([[IPCAppManager sharedManager].storeResult.sex isEqualToString:@"女"]) {
        [self.loginHeadImage setImage:[UIImage imageNamed:@"icon_login_head_femal"]];
    }else{
        [self.loginHeadImage setImage:[UIImage imageNamed:@"icon_login_head_male"]];
    }
    [self.loginUserNameLabel setText:[IPCAppManager sharedManager].storeResult.employee.name];
    [self.loginPhoneLabel setText:[IPCAppManager sharedManager].storeResult.contacterPhone];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
