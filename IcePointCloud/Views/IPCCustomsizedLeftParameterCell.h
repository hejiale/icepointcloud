//
//  IPCCustomsizedLeftParameterCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomsizedParameterView.h"
#import "IPCPayOrderViewCellDelegate.h"

@interface IPCCustomsizedLeftParameterCell : UITableViewCell

@property (nonatomic, strong) IPCCustomsizedParameterView * parameterView;
@property (weak, nonatomic) IBOutlet UIView *parameterContentView;
@property (nonatomic, assign) id<IPCPayOrderViewCellDelegate>delegate;

@end
