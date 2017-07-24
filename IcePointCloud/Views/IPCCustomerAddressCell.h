//
//  CustomerAddressListCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IPCCustomerAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *addressContentView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactNameWidth;
@property (weak, nonatomic) IBOutlet UILabel *noAddressLabel;

@property (copy, nonatomic) IPCCustomerAddressMode * addressMode;

@end

