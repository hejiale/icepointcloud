//
//  UserDetailInfoCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerDetailCell.h"

@implementation IPCCustomerDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurrentCustomer:(IPCDetailCustomer *)currentCustomer
{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer)
    {
        NSString * pointValue = [NSString stringWithFormat:@"%d积分",_currentCustomer.integral];
        CGFloat width = [pointValue jk_sizeWithFont:self.pointLabel.font constrainedToHeight:self.pointLabel.jk_height].width;
        self.pointWidth.constant = width + 25;
    
        [self.headImageView setImageURL:[NSURL URLWithString:_currentCustomer.photo_url]];
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.phoneLabel setText:_currentCustomer.customerPhone];
        [self.birthdayLabel setText:_currentCustomer.birthday];
        [self.memoLabel setText:_currentCustomer.remark];
        [self.genderLabel setText:[IPCCommon formatGender:_currentCustomer.gender]];
        [self.memberLevlLabel setText:_currentCustomer.memberLevel];
        [self.totalPayAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",_currentCustomer.consumptionAmount]];
        [self.storeValueLabel setText:[NSString stringWithFormat:@"￥%.2f",_currentCustomer.balance]];
        [self.pointLabel setText:pointValue];
        [self.customerCategoryLabel setText:_currentCustomer.customerType];
        [self.growthLabel setText:_currentCustomer.membergrowth];
        [self.ageLabel setText:_currentCustomer.age];
        if (_currentCustomer.discount) {
            [self.discountLabel setText:[NSString stringWithFormat:@"%.f%%%", _currentCustomer.discount*10]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
