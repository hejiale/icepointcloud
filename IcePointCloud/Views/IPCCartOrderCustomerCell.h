//
//  ShoppingCustomerCell.h
//  IcePointCloud
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCartOrderCustomerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextFiled;
@property (strong, nonatomic) IPCDetailCustomer * currentCustomer;

@end

