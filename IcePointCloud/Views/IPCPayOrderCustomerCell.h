//
//  ShoppingCustomerCell.h
//  IcePointCloud
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderCustomerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *growthValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;


@property (strong, nonatomic) IPCDetailCustomer * currentCustomer;

@end

