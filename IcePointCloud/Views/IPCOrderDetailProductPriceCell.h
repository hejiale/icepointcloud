//
//  OrderProductPriceCell.h
//  IcePointCloud
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderDetailProductPriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * beforePriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *afterPriceWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beforePriceWidth;
@property (weak, nonatomic) IBOutlet UILabel * afterPriceLabel;

- (void)inputBeforeDiscountPrice:(double)beforePrice AfterPrice:(double)afterPrice;

@end
