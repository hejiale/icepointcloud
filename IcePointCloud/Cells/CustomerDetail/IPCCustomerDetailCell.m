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
    
    [self.upgradeMemberButton addBorder:13 Width:1 Color:COLOR_RGB_BLUE];
}

- (void)setCurrentCustomer:(IPCDetailCustomer *)currentCustomer
{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer)
    {
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.phoneLabel setText:_currentCustomer.customerPhone];
        [self.birthdayLabel setText:_currentCustomer.birthday];
        [self.memoLabel setText:_currentCustomer.remark];
        [self.genderLabel setText:[IPCCommon formatGender:_currentCustomer.gender]];
        
        if (_currentCustomer.memberLevel) {
            [self.memberLevlLabel setHidden:NO];
            [self.memberLevlLabel setText:_currentCustomer.memberLevel.memberLevel];
            [self.discountLabel setText:[NSString stringWithFormat:@"%.f%%%", _currentCustomer.memberLevel.discount*10]];
        }else{
            [self.upgradeMemberButton setHidden:NO];
        }
        
        [self.totalPayAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",_currentCustomer.consumptionAmount]];
        [self.storeValueLabel setText:[NSString stringWithFormat:@"￥%.2f",_currentCustomer.balance]];
        [self.pointLabel setText:[NSString stringWithFormat:@"%d",_currentCustomer.integral]];
        [self.customerCategoryLabel setText:_currentCustomer.customerType];
        [self.growthLabel setText:_currentCustomer.membergrowth];
        [self.ageLabel setText:_currentCustomer.age];
    }
}


- (IBAction)upgradeMemberAction:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
