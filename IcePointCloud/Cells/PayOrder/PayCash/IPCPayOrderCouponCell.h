//
//  IPCPayOrderCouponCell.h
//  IcePointCloud
//
//  Created by gerry on 2018/6/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderCouponCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *useConditionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *useScenarioLabel;
@property (weak, nonatomic) IBOutlet UILabel *useDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (copy, nonatomic) IPCPayOrderCoupon * coupon;

- (void)refreshStatus:(BOOL)isSelect;

@end
