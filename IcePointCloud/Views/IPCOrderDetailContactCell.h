//
//  OrderDetailContactCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderDetailContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeightConstraint;

- (void)inputContactInfo:(IPCCustomerOrderInfo *)customer;


@end
