//
//  HistoryOptometryCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCMangerOptometryView.h"

@interface IPCCustomerOptometryCell : UITableViewCell

@property (strong, nonatomic) IPCMangerOptometryView * optometryView;
@property (copy, nonatomic) IPCOptometryMode * optometryMode;

@end


