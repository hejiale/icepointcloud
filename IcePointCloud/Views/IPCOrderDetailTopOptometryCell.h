//
//  IPCOrderDetailOptometryCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomerOrderDetailDelegate.h"

@interface IPCOrderDetailTopOptometryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *packUpButton;
@property (assign, nonatomic) id<IPCCustomerOrderDetailDelegate>delegate;

@end
