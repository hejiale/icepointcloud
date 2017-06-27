//
//  HistoryOptometryCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomerOptometryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *optometryContentView;
@property (weak, nonatomic) IBOutlet UILabel *insertDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

@property (strong, nonatomic) UIButton * defaultButton;
@property (copy, nonatomic) IPCOptometryMode * optometryMode;

@end


