//
//  IPCPayOrderSettlementCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPayOrderViewCellDelegate.h"

@interface IPCPayOrderSettlementCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *pointView;//使用积分兑换时隐藏
@property (weak, nonatomic) IBOutlet UILabel *pointAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *pointAmountTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectPointButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointHeight;
@property (weak, nonatomic) IBOutlet UITextField *givingAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftGivingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *givingAmountLabel;

@property (nonatomic, assign) id<IPCPayOrderViewCellDelegate>delegate;



@end
