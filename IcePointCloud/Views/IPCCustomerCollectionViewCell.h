//
//  CustomerCollectionViewCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomerCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (copy, nonatomic) IPCCustomerMode * currentCustomer;

@end
