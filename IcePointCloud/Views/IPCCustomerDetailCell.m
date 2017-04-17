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
    
    if (_currentCustomer) {
        [self.headImageView setImage:[UIImage imageNamed:[IPCHeadImage  gender:_currentCustomer.contactorGengerString Size:@"Large" Tag:_currentCustomer.photo_uuid]]];
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.phoneLabel setText:_currentCustomer.customerPhone];
        [self.birthdayLabel setText:_currentCustomer.birthday];
        [self.emailLabel setText:_currentCustomer.email];
        [self.memoLabel setText:_currentCustomer.remark];
        [self.genderLabel setText:[IPCCommon formatGender:_currentCustomer.contactorGengerString]];
        [self.handlersLabel setText:_currentCustomer.empName];
        [self.memberNumLabel setText:_currentCustomer.memberId];
        [self.memberLevlLabel setText:_currentCustomer.memberLevel];
        [self.jobLabel setText:@""];
        [self.customerCategoryLabel setText:_currentCustomer.customerType];
        [self.returnVisitDateLabel setText:_currentCustomer.lastPhoneReturn];
        [self.totalPayAmountLabel setText:[NSString stringWithFormat:@"￥%.f",_currentCustomer.consumptionAmount]];
        [self.storeValueLabel setText:[NSString stringWithFormat:@"￥%.f",_currentCustomer.balance]];
        [self.bookDateLabel setText:_currentCustomer.createDate];
        [self.pointLabel setText:[NSString stringWithFormat:@"%.f积分",_currentCustomer.integral]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
