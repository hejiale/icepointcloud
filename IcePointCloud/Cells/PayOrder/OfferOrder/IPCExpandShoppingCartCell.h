//
//  ExpandableShoppingCartCell.h
//  IcePointCloud
//
//  Created by mac on 8/27/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCShoppingCartItem.h"

@protocol IPCExpandShoppingCartCellDelegate;

@interface IPCExpandShoppingCartCell : UITableViewCell

@property (nonatomic, strong) IPCShoppingCartItem * cartItem;

@property (strong, nonatomic)  IPCCustomTextField * inputPriceTextField;

@property (nonatomic, assign) id<IPCExpandShoppingCartCellDelegate>delegate;


@end

@protocol IPCExpandShoppingCartCellDelegate <NSObject>

- (void)preEditing:(IPCExpandShoppingCartCell *)cell;

- (void)nextEditing:(IPCExpandShoppingCartCell *)cell;

- (void)endEditing:(IPCExpandShoppingCartCell *)cell;

@end




