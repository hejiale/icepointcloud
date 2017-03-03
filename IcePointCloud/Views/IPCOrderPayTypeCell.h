//
//  IPCOrderPayTypeCell.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderPayTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *employeTextField;
@property (weak, nonatomic) IBOutlet UISwitch *employeSwitch;

- (void)updateUIWithEmployee:(void(^)())employe Update:(void(^)())update;

@end
