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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftPadding;

@property (nonatomic) BOOL   isInOrder;
@property (nonatomic, strong) IPCShoppingCartItem * cartItem;

- (void)setCartItem:(IPCShoppingCartItem *)cartItem
              Count:(void(^)())count
             Expand:(void(^)())expand
               Cart:(void(^)())cart;

@end




