//
//  UserBaseTopTitleCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel   * leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *noPayPriceView;
@property (weak, nonatomic) IBOutlet UILabel *noPayPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (void)setLeftTitle:(NSString *)title;
- (void)setRightTitle:(NSAttributedString *)title;
- (void)setNoPayTitle:(NSString *)title;
- (void)setRightOperation:(NSString *)title
              ButtonTitle:(NSString *)button
              ButtonImage:(NSString *)buttonImage;

@end

