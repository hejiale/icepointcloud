//
//  UserBaseTopTitleCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomerTopTitleCell : UITableViewCell

@property (strong, nonatomic) IPCStaticImageTextButton * titleButton;

- (void)setButtonTitle:(NSString *)title IsShow:(BOOL)isShow;

@end

