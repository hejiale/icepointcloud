//
//  IPCPayAmountStyleCell.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayAmountStyleCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *payAmountButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *prePayAmountTextField;
@property (weak, nonatomic) IBOutlet UIButton *prePayAmountButton;
@property (assign, nonatomic) BOOL  isPreSell;

- (void)updateUI:(void(^)())update;

@end
