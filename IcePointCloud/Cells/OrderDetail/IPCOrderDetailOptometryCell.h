//
//  IPCOrderDetailOptometryCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCShowOptometryView.h"

@interface IPCOrderDetailOptometryCell : UITableViewCell

@property (strong, nonatomic) IPCShowOptometryView * optometryView;
@property (strong, nonatomic) IPCOptometryMode * optometry;

@end
