//
//  CustomerCollectionViewCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointViewWidth;



@property (copy, nonatomic) IPCCustomerMode * currentCustomer;

@end
