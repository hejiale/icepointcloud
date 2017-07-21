//
//  IPCCartViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCartViewMode : NSObject

@property (strong, nonatomic, readwrite) NSMutableArray<IPCContactLenSpecList *> * contactSpecificationArray;

/**
 *  Contact lenses for inventory
 */
- (void)reloadContactLensStock;

/**
 *  Judgment for the shopping cart contact lenses in stock
 *
 *  @param cartItem
 *
 *  @return 
 */
- (BOOL)judgeContactLensStock:(IPCShoppingCartItem *)cartItem;

- (BOOL)shoppingCartIsEmpty;

- (BOOL)judgeCartItemSelectState;

- (void)changeAllCartItemSelected:(BOOL)isSelected;

- (void)requestTradeOrExchangeStatus:(void(^)())complete;


@end
