//
//  IPCPayAmountStyleCell.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCEmployeePerformanceView.h"
#import "IPCPayOrderSubViewDelegate.h"

@interface IPCPayOrderEmployeeCell : UITableViewCell

@property (nonatomic, assign) id<IPCPayOrderSubViewDelegate>delegate;

@end
