//
//  UserBaseTopTitleCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomerTopTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel   *topTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (void)setTopTitle:(NSString *)title;
- (void)setInsertTitle:(NSString *)title;
- (void)setEditTitle:(NSString *)title;

@end

