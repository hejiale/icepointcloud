//
//  IPCPayOrderCustomerCollectionViewCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderCustomerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (copy, nonatomic) NSString * selectCustomerId;
@property (copy, nonatomic) IPCCustomerMode * currentCustomer;

@end
