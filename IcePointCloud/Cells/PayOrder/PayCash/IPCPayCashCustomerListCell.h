//
//  IPCPayCashCustomerListCell.h
//  IcePointCloud
//
//  Created by gerry on 2018/1/31.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayCashCustomerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (copy, nonatomic) IPCCustomerMode * customer;

@end
