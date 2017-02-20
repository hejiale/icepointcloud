//
//  CustomerAddressListCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IPCCustomerAddressListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactLeftLeading;
@property (copy, nonatomic) IPCCustomerAddressMode * addressMode;

@end

