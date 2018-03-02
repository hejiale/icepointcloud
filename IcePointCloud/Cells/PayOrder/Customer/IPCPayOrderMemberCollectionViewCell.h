//
//  IPCPayOrderMemberCollectionViewCell.h
//  IcePointCloud
//
//  Created by gerry on 2018/2/27.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderMemberCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *encryptedPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLevelLabel;
@property (copy, nonatomic) IPCCustomerMode * currentCustomer;

@end
