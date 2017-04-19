//
//  IPCShoppingCart.h
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCShoppingCartItem.h"

@interface IPCShoppingCart : NSObject

+ (IPCShoppingCart *)sharedCart;

@property (nonatomic, strong, readwrite) NSMutableArray<IPCShoppingCartItem *> *itemList;

/**
 *    To obtain the corresponding number of shopping cart
 */
- (NSInteger)itemsCount;
- (NSInteger)cardItemsCount;
//- (NSInteger)selectedItemsCount;
- (NSInteger)selectPayItemsCount;
- (NSInteger)selectNormalItemsCount;
//- (NSInteger)selectedPreSellItemsCount;
- (NSInteger)selectedGlassesCount;
- (NSInteger)selectValueCardCount;
- (NSInteger)allGlassesCount;
- (NSUInteger)itemsCount:(IPCShoppingCartItem *)cartItem;
- (NSInteger)singleGlassesCount:(IPCGlasses *)glasses;
/**
 *    Calculate the total price shopping cart selected goods
 */
- (double)selectedGlassesTotalPrice;
//- (double)selectedPreSellGlassesTotalPrice;
//- (double)selectedNormalSellGlassesTotalPrice;
- (double)selectedValueCardTotalPrice;
- (double)selectedPayItemTotalPrice;
/**
 *   The selected shopping cart of goods
 */
- (NSArray<IPCShoppingCartItem *> *)selectCartItems;
//- (NSArray<IPCShoppingCartItem *>*)selectPreSellCartItems;
- (NSArray<IPCShoppingCartItem *>*)selectValueCardCartItems;
/**
 *    Remove the shopping cart
 */
- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeItem:(IPCShoppingCartItem *)item;
- (void)removeSelectCartItem;
- (void)removeAllValueCardCartItem;
- (void)reduceItem:(IPCShoppingCartItem *)cartItem;
- (void)reduceGlass:(IPCGlasses *)glass;
/**
 *     Add a shopping cart
 */
//- (void)addGlasses:(IPCGlasses *)glasses  Count:(NSInteger)count;
- (void)addLensWithGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl Count:(NSInteger)count;
- (void)addReadingLensWithGlasses:(IPCGlasses *)glasses ReadingDegree:(NSString *)readingDegree  Count:(NSInteger)count;
- (void)addContactLensWithGlasses:(IPCGlasses *)glasses ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date  ContactID:(NSString *)contactID Count:(NSInteger)count;
- (void)addAccessoryWithGlasses:(IPCGlasses *)glasses BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date Count:(NSInteger)count;
//- (void)addPreSellContactLensWithGlasses:(IPCGlasses *)glasses ContactDegree:(NSString *)contactDegree Count:(NSInteger)count;
//- (void)addPreSellAccessoryWithGlasses:(IPCGlasses *)glasses Count:(NSInteger)count;
- (void)addValueCard:(IPCGlasses *)glass;
- (void)plusItem:(IPCShoppingCartItem *)cartItem;
- (void)plusGlass:(IPCGlasses *)glass;
/**
 *    Remove glasses category shopping cart items accordingly
 */
- (void)removeGlasses:(IPCGlasses *)glasse;
- (void)clear;
/**
 *   To obtain the corresponding glasses category shopping cart items
 */
- (IPCShoppingCartItem *)normalItemForGlasses:(IPCGlasses *)glasses;
- (IPCShoppingCartItem *)batchLensForGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl;
- (IPCShoppingCartItem *)readingLensForGlasses:(IPCGlasses *)glasses ReadingDegree:(NSString *)readingDegree;
//- (IPCShoppingCartItem *)preSellcontactLensForGlasses:(IPCGlasses *)glasses  ContactDegree:(NSString *)contactDegree;
- (IPCShoppingCartItem *)contactLensForGlasses:(IPCGlasses *)glasses  ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date;
//- (IPCShoppingCartItem *)preSellAccessoryForGlass:(IPCGlasses *)glasses;
- (IPCShoppingCartItem *)batchAccessoryForGlass:(IPCGlasses *)glasses BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date;

- (IPCShoppingCartItem *)itemAtIndex:(NSInteger)index;
- (IPCShoppingCartItem *)selectedItemAtIndex:(NSInteger)index;
- (IPCShoppingCartItem *)selectedNormalSelltemAtIndex:(NSInteger)index;
//- (IPCShoppingCartItem *)selectedPreSelltemAtIndex:(NSInteger)index;
- (IPCShoppingCartItem *)selectedPayItemAtIndex:(NSInteger)index;

- (NSArray<IPCShoppingCartItem *> *)batchParameterList:(IPCGlasses *)glasses;
/**
 *   Send the shopping cart number change notification
 */
- (void)postChangedNotification;

@end
