//
//  UserBaseTopTitleCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerDetailTopCell.h"

@interface IPCCustomerDetailTopCell()


@end

@implementation IPCCustomerDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLeftTitle:(NSString *)title
{
    [self.leftTitleLabel setText:title];
}

- (void)setNoPayTitle:(NSString *)title{
    [self.noPayPriceView setHidden:NO];
    [self.noPayPriceLabel setText:title];
}

- (void)setRightOperation:(NSString *)title
              ButtonTitle:(NSString *)button
              ButtonImage:(NSString *)buttonImage
{
    [self.rightButton setHidden:NO];
    
    if (title) {
        [self.leftTitleLabel setText:title];
    }
    if (button) {
        [self.rightButton setTitle:button forState:UIControlStateNormal];
    }
    if (buttonImage) {
        [self.rightButton setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
    }
}

#pragma mark //Clicked Events
- (IBAction)rightButtonAction:(id)sender {
    
}

@end
