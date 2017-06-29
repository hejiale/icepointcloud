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
- (NSInteger)selectPayItemsCount;
- (NSInteger)selectNormalItemsCount;
- (NSInteger)selectedGlassesCount;
- (NSInteger)valueCardCount;
- (NSInteger)allGlassesCount;
- (NSInteger)itemsCount:(IPCShoppingCartItem *)cartItem;
- (NSInteger)singleGlassesCount:(IPCGlasses *)glasses;
/**
 *    Calculate the total price shopping cart selected goods
 */
- (double)selectedGlassesTotalPrice;
- (double)selectedValueCardTotalPrice;
- (double)selectedPayItemTotalPrice;
/**
 *   The selected shopping cart of goods
 */
- (NSArray<IPCShoppingCartItem *> *)selectCartItems;
- (NSArray<IPCShoppingCartItem *>*)selectValueCardCartItems;
- (NSArray<IPCShoppingCartItem *> *)selectPayCartItems;
/**
 *    Remove the shopping cart
 */
- (void)removeItem:(IPCShoppingCartItem *)item;
- (void)removeSelectCartItem;
- (void)removeAllValueCardCartItem;
- (void)removeGlasses:(IPCGlasses *)glasse;
- (void)clear;
/**
 *     Add a shopping cart
 */
- (void)addLensWithGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl Count:(NSInteger)count;
- (void)addReadingLensWithGlasses:(IPCGlasses *)glasses ReadingDegree:(NSString *)readingDegree  Count:(NSInteger)count;
- (void)addContactLensWithGlasses:(IPCGlasses *)glasses ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date  ContactID:(NSString *)contactID Count:(NSInteger)count;
- (void)addAccessoryWithGlasses:(IPCGlasses *)glasses BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date Count:(NSInteger)count;
- (void)addValueCard:(IPCGlasses *)glass;
/**
 *   Plus Cart Item
 */
- (void)plusItem:(IPCShoppingCartItem *)cartItem;
- (void)plusGlass:(IPCGlasses *)glass;
/**
 *   Reduce Cart Item
 */
- (void)reduceItem:(IPCShoppingCartItem *)cartItem;
/**
 *   To obtain the corresponding glasses category shopping cart items
 */
- (IPCShoppingCartItem *)normalItemForGlasses:(IPCGlasses *)glasses;
- (IPCShoppingCartItem *)batchLensForGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl;
- (IPCShoppingCartItem *)readingLensForGlasses:(IPCGlasses *)glasses ReadingDegree:(NSString *)readingDegree;
- (IPCShoppingCartItem *)contactLensForGlasses:(IPCGlasses *)glasses  ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date;
- (IPCShoppingCartItem *)batchAccessoryForGlass:(IPCGlasses *)glasses BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date;

- (IPCShoppingCartItem *)itemAtIndex:(NSInteger)index;
- (IPCShoppingCartItem *)selectedPayItemAtIndex:(NSInteger)index;

- (NSArray<IPCShoppingCartItem *> *)batchParameterList:(IPCGlasses *)glasses;
/**
 *   Send the shopping cart number change notification
 */
- (void)postChangedNotification;

/**
 *   Point Value
 */
- (void)clearAllItemPoint;
- (NSInteger)totalUsedPoint;
- (double)totalUsedPointPrice;
- (BOOL)isHaveUsedPoint;
/**
 *   Reset Select Cart UnitPrice
 */
- (void)resetSelectCartItemPrice;

@end
