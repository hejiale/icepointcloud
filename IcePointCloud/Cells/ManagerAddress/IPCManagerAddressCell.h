//
//  IPCEditAddressCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCManagerAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactNameWidth;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (copy, nonatomic) IPCCustomerAddressMode * addressMode;

@end
