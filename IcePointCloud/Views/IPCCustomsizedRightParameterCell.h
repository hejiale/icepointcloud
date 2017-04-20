//
//  IPCCustomsizedRightParameterCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomsizedParameterView.h"

@interface IPCCustomsizedRightParameterCell : UITableViewCell

@property (nonatomic, strong) IPCCustomsizedParameterView * parameterView;
@property (weak, nonatomic) IBOutlet UIView *parameterContentView;
@property (weak, nonatomic) IBOutlet UIButton *unifiedButton;
@property (weak, nonatomic) IBOutlet UIButton *leftOrRightEyeButton;

- (void)reloadUI:(void(^)())update;

@end
