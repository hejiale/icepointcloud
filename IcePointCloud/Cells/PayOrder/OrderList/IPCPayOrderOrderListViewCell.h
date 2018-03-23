//
//  IPCPayOrderOrderListViewCell.h
//  IcePointCloud
//
//  Created by gerry on 2018/3/21.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderOrderListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (copy, nonatomic) IPCCustomerOrderMode * customerOrder;
@property (copy, nonatomic)  NSString * orderNum;

@end
