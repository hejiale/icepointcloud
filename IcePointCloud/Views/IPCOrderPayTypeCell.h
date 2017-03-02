//
//  IPCOrderPayTypeCell.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderPayTypeCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *employeTextField;
@property (weak, nonatomic) IBOutlet UISwitch *employeSwitch;

- (void)updateUI:(void(^)())employe Update:(void(^)())update;

@end
