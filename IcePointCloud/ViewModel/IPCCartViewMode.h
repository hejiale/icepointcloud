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
//@property (strong, nonatomic, readwrite) IPCAccessorySpecList * accessorySpecification;

/**
 *  Contact lenses for inventory
 */
//- (void)reloadContactLensStock;

/**
 *  Judgment for the shopping cart contact lenses in stock
 *
 *  @param cartItem
 *
 *  @return 
 */
//- (BOOL)judgeContactLensStock:(IPCShoppingCartItem *)cartItem;

- (BOOL)shoppingCartIsEmpty;

- (BOOL)judgeCartItemSelectState;

- (void)changeAllCartItemSelected:(BOOL)isSelected;

/**
 *  Query the corresponding nursing liquid inventory
 *
 *  @param cartItem
 *  @param Complete
 */
//- (void)queryAccessoryStock:(IPCShoppingCartItem *)cartItem Complete:(void(^)(BOOL hasStock))complete;

@end
