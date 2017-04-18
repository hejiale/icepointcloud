//
//  CustomerCollectionViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerCollectionViewCell.h"

@implementation IPCCustomerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setCurrentCustomer:(IPCCustomerMode *)currentCustomer{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer) {
        NSString * pointText = [NSString stringWithFormat:@"%@积分",_currentCustomer.integral];
        CGFloat pointWidth = [pointText jk_sizeWithFont:self.pointLabel.font constrainedToHeight:self.pointLabel.jk_height].width;
        self.pointViewWidth.constant = pointWidth + 25;
        
        [self.customImageView setImage:[UIImage imageNamed:[IPCHeadImage  gender:_currentCustomer.gender Size:@"small" Tag:_currentCustomer.photoIdForPos]]];
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.customerPhoneLabel setText:_currentCustomer.customerPhone];
        [self.pointLabel setText:pointText];
        if (_currentCustomer.memberLevel && _currentCustomer.memberLevel.length) {
            [self.memberLevelLabel setText:_currentCustomer.memberLevel];
        }
    }
}

@end
