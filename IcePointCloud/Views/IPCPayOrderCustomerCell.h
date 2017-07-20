//
//  IPCPayOrderCustomerCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderCustomerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLevlLabel;

@property (copy, nonatomic) IPCDetailCustomer * currentCustomer;

@end
