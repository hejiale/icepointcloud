//
//  IPCEditShoppingCartCell.h
//  IcePointCloud
//
//  Created by mac on 2017/2/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCShoppingCartItem.h"

@interface IPCEditShoppingCartCell : UITableViewCell

@property (nonatomic, strong) IPCShoppingCartItem * cartItem;
- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload;

@end
