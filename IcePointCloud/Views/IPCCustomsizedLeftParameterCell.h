//
//  IPCCustomsizedLeftParameterCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomsizedParameterView.h"

@interface IPCCustomsizedLeftParameterCell : UITableViewCell

@property (nonatomic, strong) IPCCustomsizedParameterView * parameterView;
@property (weak, nonatomic) IBOutlet UIView *parameterContentView;

- (void)reloadUI:(void(^)())update;

@end
