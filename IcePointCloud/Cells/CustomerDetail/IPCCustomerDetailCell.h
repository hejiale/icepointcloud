//
//  UserDetailInfoCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomerDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLevlLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPayAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *growthLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *upgradeMemberButton;


@property (copy, nonatomic) IPCDetailCustomer * currentCustomer;


@end

