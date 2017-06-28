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
    
    [self.loginUserNameLabel setText:[IPCAppManager sharedManager].profile.contacterName];
    [self.loginPhoneLabel setText:[IPCAppManager sharedManager].profile.contacterPhone];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
