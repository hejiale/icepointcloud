//
//  IPCPayOrderSettlementCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPayOrderSubViewDelegate.h"

@interface IPCPayOrderSettlementCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *pointAmountTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectPointButton;
@property (weak, nonatomic) IBOutlet UILabel *customerPointLabel;
@property (weak, nonatomic) IBOutlet UITextField *payAmountTextField;
@property (weak, nonatomic) IBOutlet UIButton *fullAmountButton;
@property (weak, nonatomic) IBOutlet UIButton *depositButton;
@property (weak, nonatomic) IBOutlet UITextField *depositTextField;
@property (weak, nonatomic) IBOutlet UILabel *givingAmountLabel;
@property (nonatomic, assign) id<IPCPayOrderSubViewDelegate>delegate;


- (void)updateUI;


@end
