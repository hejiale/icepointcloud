//
//  IPCPayOrderProductCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/3/22.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPayOrderViewCellDelegate.h"

@interface IPCPayOrderProductCell : UITableViewCell

@property (nonatomic, strong) IPCShoppingCartItem * cartItem;
@property (nonatomic, assign) id<IPCPayOrderViewCellDelegate>delegate;

@end

