//
//  IPCPayAmountStyleCell.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCEmployeePerformanceView.h"
#import "IPCPayOrderViewCellDelegate.h"

@interface IPCPayOrderEmployeeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *employeeScrollView;
@property (nonatomic, assign) id<IPCPayOrderViewCellDelegate>delegate;

@end
