//
//  IPCEditOptometryCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCMangerOptometryView.h"

@interface IPCManagerOptometryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *optometryContentView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (nonatomic, strong) IPCMangerOptometryView * optometryView;
@property (nonatomic, copy) IPCOptometryMode * optometryMode;

@end

