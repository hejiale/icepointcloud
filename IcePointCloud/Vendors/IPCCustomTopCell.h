//
//  UserBaseTopTitleCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel   *topTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *searchCustomerButton;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *noPayPriceView;
@property (weak, nonatomic) IBOutlet UILabel *noPayPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (void)setTopTitle:(NSString *)title;
- (void)setInsertTitle:(NSString *)title;
- (void)setEditTitle:(NSString *)title;
- (void)setRightTitle:(NSAttributedString *)title;
- (void)setNoPayTitle:(NSString *)title;
- (void)setRightManagerTitle:(NSString *)title;

@end

