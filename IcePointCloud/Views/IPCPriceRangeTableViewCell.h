//
//  PriceRangeTableViewCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPriceRangeTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *endPriceTextField;

@end



