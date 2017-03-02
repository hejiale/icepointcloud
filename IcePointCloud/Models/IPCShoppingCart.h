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

@property (nonatomic, strong) NSMutableArray<IPCShoppingCartItem *> *itemList;

/**
 *    To obtain the corresponding number of shopping cart
 */
- (NSInteger)itemsCount;
- (NSInteger)selectedItemsCount;
- (NSInteger)selectedGlassesCount;
- (NSInteger)allGlassesCount;
- (NSUInteger)itemsCount:(IPCShoppingCartItem *)cartItem;
- (NSInteger)singleGlassesCount:(IPCGlasses *)glasses;
/**
 *    Calculate the total price shopping cart selected goods
 */
- (double)selectedGlassesTotalPrice;
/**
 *   The selected shopping cart of goods
 */
- (NSArray<IPCShoppingCartItem *> *)selectCartItems;
/**
 *    Remove the shopping cart
 */
- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeItem:(IPCShoppingCartItem *)item;
- (void)removeSelectCartItem;
- (void)reduceItem:(IPCShoppingCartItem *)cartItem;
- (void)plusItem:(IPCShoppingCartItem *)cartItem;
/**
 *     Add a shopping cart
 */
- (void)addGlasses:(IPCGlasses *)glasses;
- (void)addGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date  ContactID:(NSString *)contactID IsOpenBooking:(BOOL)isOpenBooking;
/**
 *    Remove glasses category shopping cart items accordingly
 */
- (void)removeGlasses:(IPCGlasses *)glasse;
- (void)removeGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date IsOpenBooking:(BOOL)isOpenBooking;
- (void)clear;
/**
 *   To obtain the corresponding glasses category shopping cart items
 */
- (IPCShoppingCartItem *)normalItemForGlasses:(IPCGlasses *)glasses;
- (IPCShoppingCartItem *)batchItemForGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl  ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date IsOpenBooking:(BOOL)isOpenBooking;
- (IPCShoppingCartItem *)itemAtIndex:(NSInteger)index;
- (IPCShoppingCartItem *)selectedItemAtIndex:(NSInteger)index;
- (NSArray<IPCShoppingCartItem *> *)batchParameterList:(IPCGlasses *)glasses;
/**
 *   Send the shopping cart number change notification
 */
- (void)postChangedNotification;

/**
    replace new cart item
 */
- (void)replaceNewCartItem:(IPCShoppingCartItem *)newCartItem OldCartItem:(IPCShoppingCartItem *)oldCartItem;


@end
