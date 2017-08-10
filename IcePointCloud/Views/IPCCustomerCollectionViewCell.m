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
    
    [self.imageContentView addSubview:self.customImageView];
}

- (UIImageView *)customImageView{
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc] initWithFrame:self.imageContentView.bounds];
        [_customImageView zy_cornerRadiusAdvance:self.imageContentView.jk_height/2  rectCornerType:UIRectCornerAllCorners];
    }
    return _customImageView;
}


- (void)setCurrentCustomer:(IPCCustomerMode *)currentCustomer{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer)
    {
        NSString * pointText = [NSString stringWithFormat:@"%@积分",_currentCustomer.integral];
        CGFloat pointWidth = [pointText jk_sizeWithFont:self.pointLabel.font constrainedToHeight:self.pointLabel.jk_height].width;
        self.pointViewWidth.constant = pointWidth + 25;
        
        [self.customImageView setImageURL:[NSURL URLWithString:_currentCustomer.photoUrl]];
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.customerPhoneLabel setText:_currentCustomer.customerPhone];
        [self.pointLabel setText:pointText];
        [self.memberLevelLabel setText:_currentCustomer.memberlevel];
    }
}

@end
