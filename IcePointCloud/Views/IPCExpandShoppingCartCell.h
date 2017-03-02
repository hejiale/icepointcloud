//
//  ExpandableShoppingCartCell.h
//  IcePointCloud
//
//  Created by mac on 8/27/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCShoppingCartItem.h"

@interface IPCExpandShoppingCartCell : UITableViewCell

@property (nonatomic, strong) IPCShoppingCartItem * cartItem;
@property (nonatomic, assign) BOOL  isOrder;

- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload;

@end




