//
//  UserBaseOpometryCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCEditOptometryView.h"

@interface IPCCustomerBaseOpometryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *optometryView;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (strong, nonatomic) IPCEditOptometryView * editOptometryView;

- (void)setAllSubViewDisabled:(BOOL)isDisable Complete:(void(^)())complete;

@end

