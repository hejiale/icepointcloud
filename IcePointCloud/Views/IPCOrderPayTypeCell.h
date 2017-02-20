//
//  IPCOrderPayTypeCell.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderPayTypeCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *payAmountButton;
@property (weak, nonatomic) IBOutlet UIButton *installmentButton;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) IBOutlet UITextField *installmentTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *employeTextField;
@property (weak, nonatomic) IBOutlet UISwitch *employeSwitch;
@property (weak, nonatomic) IBOutlet UIView *employeBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *employeHeightConstraint;


- (void)updateUI:(void(^)())employe Update:(void(^)())update;

@end
