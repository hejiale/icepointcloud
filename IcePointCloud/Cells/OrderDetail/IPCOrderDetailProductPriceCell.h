//
//  OrderProductPriceCell.h
//  IcePointCloud
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderDetailProductPriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *realTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *givingAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (copy, nonatomic) IPCCustomerOrderInfo * orderInfo;


@end
