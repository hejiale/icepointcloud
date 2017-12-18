//
//  IPCPayCashPayTypeViewCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/12/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayCashPayTypeViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *payTypeNameLabel;
@property (copy, nonatomic) IPCPayOrderPayType * payType;

- (void)updateBorder:(BOOL)isUpdate;

@end
