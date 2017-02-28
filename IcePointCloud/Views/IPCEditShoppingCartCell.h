//
//  IPCEditShoppingCartCell.h
//  IcePointCloud
//
//  Created by mac on 2017/2/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCShoppingCartItem.h"

@protocol IPCEditShoppingCartCellDelegate;
@interface IPCEditShoppingCartCell : UITableViewCell

@property (nonatomic, strong) IPCShoppingCartItem * cartItem;
@property (nonatomic, assign) id<IPCEditShoppingCartCellDelegate>delegate;
- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload;

@end

@protocol IPCEditShoppingCartCellDelegate <NSObject>

- (void)chooseParameter:(IPCEditShoppingCartCell *)cell;
- (void)judgeStock:(IPCEditShoppingCartCell *)cell;

@end
