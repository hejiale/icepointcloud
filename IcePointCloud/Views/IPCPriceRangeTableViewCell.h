//
//  PriceRangeTableViewCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriceRangeTableViewCellDelegate;
@interface IPCPriceRangeTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *endPriceTextField;
@property (weak, nonatomic) id<PriceRangeTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@protocol PriceRangeTableViewCellDelegate <NSObject>

- (void)reloadPriceRangProducts:(double)startPirce EndPrice:(double)endPrice;

@end


