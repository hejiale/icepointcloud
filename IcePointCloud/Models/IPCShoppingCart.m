//
//  IPCShoppingCart.m
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCShoppingCart.h"


@implementation IPCShoppingCart

+ (IPCShoppingCart *)sharedCart
{
    static IPCShoppingCart *cart;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        cart = [[IPCShoppingCart alloc] init];
    });
    return cart;
}

/**
 *  The shopping cart number
 *
 */
- (NSInteger)itemsCount
{
    return self.itemList.count;
}

- (NSInteger)selectedItemsCount
{
    return [self selectCartItems].count;
}

- (NSInteger)selectNormalItemsCount{
    return [self selectNormalSellCartItems].count;
}

- (NSInteger)selectedPreSellItemsCount{
    return [self selectPreSellCartItems].count;
}

- (NSInteger)selectedGlassesCount
{
    NSInteger count = 0;
    for (IPCShoppingCartItem *ci in self.itemList) {
        if (ci.selected) count += ci.count;
    }
    return count;
}

- (NSInteger)allGlassesCount
{
    NSInteger count = 0;
    for (IPCShoppingCartItem *ci in self.itemList) {
        count += ci.count;
    }
    return count;
}

- (NSUInteger)itemsCount:(IPCShoppingCartItem *)cartItem{
    __block NSInteger count = 0;
    
    for (IPCShoppingCartItem * item in self.itemList) {
        if ([item isEqual:cartItem]) {
            count = item.count;
        }
    }
    return count;
}

/**
 *  Shopping cart price calculation
 *
 */
- (double)selectedGlassesTotalPrice
{
    double price = 0;
    for (IPCShoppingCartItem *ci in self.itemList) {
        if (ci.selected) price += ci.totalPrice;
    }
    return price;
}


- (double)selectedPreSellGlassesTotalPrice
{
    double price = 0;
    for (IPCShoppingCartItem *ci in [self selectPreSellCartItems]) {
        price += ci.totalPrice;
    }
    return price;
}


- (double)selectedNormalSellGlassesTotalPrice
{
    double price = 0;
    for (IPCShoppingCartItem *ci in [self selectNormalSellCartItems]) {
        price += ci.totalPrice;
    }
    return price;
}

- (NSArray<IPCShoppingCartItem *>*)selectCartItems{
    return [self.itemList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject selected];
    }]];
}

- (NSArray<IPCShoppingCartItem *>*)selectPreSellCartItems{
    return [self.itemList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject selected] && [evaluatedObject isPreSell];
    }]];
}

- (NSArray<IPCShoppingCartItem *>*)selectNormalSellCartItems{
    return [self.itemList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject selected] && ![evaluatedObject isPreSell];
    }]];
}

/**
 *  Specify a shopping cart information
 */
- (IPCShoppingCartItem *)itemAtIndex:(NSInteger)index
{
    return self.itemList[index];
}

- (IPCShoppingCartItem *)selectedItemAtIndex:(NSInteger)index
{
    return [self selectCartItems][index];
}

- (IPCShoppingCartItem *)selectedNormalSelltemAtIndex:(NSInteger)index
{
    return [self selectNormalSellCartItems][index];
}

- (IPCShoppingCartItem *)selectedPreSelltemAtIndex:(NSInteger)index
{
    return [self selectPreSellCartItems][index];
}

/**
 *  Add a shopping cart
 *
 */
- (void)plusItem:(IPCShoppingCartItem *)cartItem{
    if (cartItem){
        cartItem.count++;
    }
    [self postChangedNotification];
}

- (void)plusGlass:(IPCGlasses *)glass{
    if (glass) {
        [self addGlasses:glass Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil ContactID:nil IsOpenBooking:NO Count:1];
    }
}


- (void)addLensWithGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil ContactID:nil IsOpenBooking:NO Count:count];
}

- (void)addReadingLensWithGlasses:(IPCGlasses *)glasses ReadingDegree:(NSString *)readingDegree  Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:nil Cyl:nil ReadingDegree:readingDegree ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil ContactID:nil IsOpenBooking:NO Count:count];
}

- (void)addContactLensWithGlasses:(IPCGlasses *)glasses ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date  ContactID:(NSString *)contactID Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:contactDegree BatchNum:batchNum KindNum:kindNum ValidityDate:date ContactID:contactID IsOpenBooking:NO Count:count];
}

- (void)addAccessoryWithGlasses:(IPCGlasses *)glasses BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:batchNum KindNum:kindNum ValidityDate:date ContactID:nil IsOpenBooking:NO Count:count];
}


- (void)addPreSellContactLensWithGlasses:(IPCGlasses *)glasses ContactDegree:(NSString *)contactDegree Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:contactDegree BatchNum:nil KindNum:nil ValidityDate:nil ContactID:nil IsOpenBooking:YES Count:count];
}

- (void)addPreSellAccessoryWithGlasses:(IPCGlasses *)glasses Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil ContactID:nil IsOpenBooking:YES Count:count];
}


- (void)addGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date  ContactID:(NSString *)contactID IsOpenBooking:(BOOL)isOpenBooking Count:(NSInteger)count
{
    IPCShoppingCartItem *item = nil;
    if (glasses.isBatch || ([glasses filterType] == IPCTopFilterTypeAccessory && glasses.solutionType) || ([glasses filterType] == IPCTopFilterTypeContactLenses) && glasses.stock == 0)
    {
        item = [self batchItemForGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:readingDegree ContactDegree:contactDegree BatchNum:batchNum KindNum:kindNum ValidityDate:date IsOpenBooking:isOpenBooking];
    }else{
        item = [self normalItemForGlasses:glasses];
    }
    
    if (item) {
        item.count += count;
    } else {
        IPCShoppingCartItem *nci = [[IPCShoppingCartItem alloc]init];
        if (glasses.isBatch || ([glasses filterType] == IPCTopFilterTypeAccessory && glasses.solutionType) || ([glasses filterType] == IPCTopFilterTypeContactLenses && glasses.stock == 0))
        {
            nci.batchSph = sph;
            nci.bacthCyl = cyl;
            nci.contactDegree = contactDegree;
            nci.batchReadingDegree = readingDegree;
            nci.kindNum = kindNum;
            nci.batchNum = batchNum;
            nci.validityDate = date;
            nci.contactLensID = contactID;
            nci.isPreSell = isOpenBooking;
        }
        nci.glasses = glasses;
        nci.count   = count;
        [self.itemList addObject:nci];
    }
    [self postChangedNotification];
}


/**
 *  Remove the corresponding shopping goods
 *
 */
- (void)removeGlasses:(IPCGlasses *)glasse{
    [self removeGlasses:glasse Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:NO];
}


- (void)removeGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date IsOpenBooking:(BOOL)isOpenBooking
{
    IPCShoppingCartItem *item = nil;
    
    if (glasses.isBatch || ([glasses filterType] ==IPCTopFilterTypeAccessory && glasses.solutionType)) {
        item = [self batchItemForGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:readingDegree ContactDegree:contactDegree BatchNum:batchNum KindNum:kindNum ValidityDate:date IsOpenBooking:isOpenBooking];
    }else{
        item = [self normalItemForGlasses:glasses];
    }
    
    if (item) {
        item.count--;
        if (item.count == 0) {
            [self.itemList removeObject:item];
        }
    }
    [self postChangedNotification];
}

- (void)removeItemAtIndex:(NSInteger)index
{
    [self removeItem:self.itemList[index]];
    [self postChangedNotification];
}

- (void)removeItem:(IPCShoppingCartItem *)item
{
    [self.itemList removeObject:item];
    [self postChangedNotification];
}

- (void)removeSelectCartItem{
    for (IPCShoppingCartItem *ci in [[IPCShoppingCart sharedCart] selectCartItems])
        [[IPCShoppingCart sharedCart] removeItem:ci];
}

- (void)reduceItem:(IPCShoppingCartItem *)cartItem{
    if (cartItem){
        cartItem.count--;
        if (cartItem.count == 0) {
            [self.itemList removeObject:cartItem];
        }
    }
    [self postChangedNotification];
}

- (void)reduceGlass:(IPCGlasses *)glass{
    if (glass) {
        IPCShoppingCartItem * item = [self normalItemForGlasses:glass];
        if (item) {
            [self reduceItem:item];
        }
    }
}

/**
 *  The same commodity type number
 *
 */
- (NSInteger)singleGlassesCount:(IPCGlasses *)glasses{
    __block NSInteger itemCount = 0;
    
    for (IPCShoppingCartItem * item in self.itemList) {
        if ([item.glasses.glassesID isEqualToString:glasses.glassesID]) {
            itemCount += item.count;
        }
    }
    return itemCount;
}

/**
 *  To clear the shopping cart
 */
- (void)clear
{
    [self.itemList removeAllObjects];
    self.itemList = nil;
    [self postChangedNotification];
}

/**
 *  Ordinary goods
 *
 */
- (IPCShoppingCartItem *)normalItemForGlasses:(IPCGlasses *)glasses
{
    for (IPCShoppingCartItem *ci in self.itemList)
        if ([ci.glasses.glassesID isEqualToString:glasses.glassesID])
            return ci;
    return nil;
}

- (IPCShoppingCartItem *)batchLensForGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl
{
    return [self batchItemForGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:NO];
}

- (IPCShoppingCartItem *)readingLensForGlasses:(IPCGlasses *)glasses ReadingDegree:(NSString *)readingDegree
{
    return [self batchItemForGlasses:glasses Sph:nil Cyl:nil ReadingDegree:readingDegree ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:NO];
}

- (IPCShoppingCartItem *)contactLensForGlasses:(IPCGlasses *)glasses  ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date
{
    return [self batchItemForGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:contactDegree BatchNum:batchNum KindNum:kindNum ValidityDate:date IsOpenBooking:NO];
}

- (IPCShoppingCartItem *)preSellcontactLensForGlasses:(IPCGlasses *)glasses  ContactDegree:(NSString *)contactDegree
{
    return [self batchItemForGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:contactDegree BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:YES];
}

- (IPCShoppingCartItem *)preSellAccessoryForGlass:(IPCGlasses *)glasses
{
    return [self batchItemForGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:YES];
}


- (IPCShoppingCartItem *)batchAccessoryForGlass:(IPCGlasses *)glasses BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date
{
    return [self batchItemForGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:batchNum KindNum:kindNum ValidityDate:date IsOpenBooking:NO];
}

- (IPCShoppingCartItem *)batchItemForGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl  ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree  BatchNum:(NSString *)batchNum KindNum:(NSString *)kindNum ValidityDate:(NSString *)date IsOpenBooking:(BOOL)isOpenBooking
{
    for (IPCShoppingCartItem *ci in self.itemList)
        if (([ci.glasses.glassesID isEqualToString:glasses.glassesID])){
            if ([glasses filterType] == IPCTopFilterTypeLens) {
                if ([cyl isEqualToString:ci.bacthCyl] && [sph isEqualToString:ci.batchSph])
                    return ci;
            }else if ([glasses filterType] == IPCTopFilterTypeReadingGlass){
                if ([readingDegree isEqualToString:ci.batchReadingDegree])
                    return ci;
            }else if([glasses filterType] == IPCTopFilterTypeContactLenses){
                if (isOpenBooking) {
                    if ([contactDegree isEqualToString:ci.contactDegree] && ci.isPreSell)
                        return ci;
                }else{
                    if ([contactDegree isEqualToString:ci.contactDegree] && [batchNum isEqualToString:ci.batchNum] && [kindNum isEqualToString:ci.kindNum] && [date isEqualToString:ci.validityDate])
                        return ci;
                }
            }else{
                if (!isOpenBooking){
                    if ([batchNum isEqualToString:ci.batchNum] && [kindNum isEqualToString:ci.kindNum] && [date isEqualToString:ci.validityDate])
                        return ci;
                }else{
                    if (ci.isPreSell) {
                        return ci;
                    }
                }
            }
        }
    return nil;
}


- (void)postChangedNotification
{
    [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCNotificationShoppingCartChanged object:nil];
}

// private methods
- (NSMutableArray<IPCShoppingCartItem *> *)itemList
{
    if (!_itemList) {
        _itemList = [NSMutableArray new];
    }
    return _itemList;
}


/**
 *  For batch parameters of similar goods
 */
- (NSArray<IPCShoppingCartItem *> *)batchParameterList:(IPCGlasses *)glasses{
    NSMutableArray * itemArray = [[NSMutableArray alloc]init];
    
    for (IPCShoppingCartItem *ci in self.itemList){
        if ([ci.glasses.glassesID isEqualToString:glasses.glassesID]) {
            [itemArray addObject:ci];
        }
    }
    return itemArray;
}

@end
