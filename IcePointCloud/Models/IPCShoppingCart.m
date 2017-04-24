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
    if ([self isExistValueCard]) {
        return [self valueCardCartItems].count;
    }
    return [self cartItems].count;
}

- (NSInteger)selectNormalItemsCount{
    return [self selectCartItems].count;
}

- (NSInteger)selectPayItemsCount
{
    if ([self isExistValueCard])
        return [self valueCardCount];
    return [self selectNormalItemsCount];
}

- (NSInteger)valueCardCount{
    return [self selectValueCardCartItems].count;
}

- (NSInteger)selectedGlassesCount
{
    NSInteger count = 0;
    for (IPCShoppingCartItem *ci in [self selectCartItems]) {
        if (ci.selected) count += ci.count;
    }
    return count;
}

- (NSInteger)allGlassesCount
{
    NSInteger count = 0;
    for (IPCShoppingCartItem *ci in self.itemList) {
        if ([ci.glasses filterType] != IPCTopFilterTypeCard) {
            count += ci.count;
        }
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
    for (IPCShoppingCartItem *ci in [self selectCartItems]) {
        price += ci.totalPrice;
    }
    return price;
}


- (double)selectedValueCardTotalPrice
{
    double price = 0;
    for (IPCShoppingCartItem *ci in [self selectValueCardCartItems]) {
        price += ci.totalPrice;
    }
    return price;
}

- (double)selectedPayItemTotalPrice
{
    if ([self isExistValueCard])
        return [self selectedValueCardTotalPrice];
    return [self selectedGlassesTotalPrice];
}

#pragma mark //CartItem Array
- (NSArray<IPCShoppingCartItem *>*)cartItems{
    return [self.itemList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject glasses] filterType] != IPCTopFilterTypeCard;
    }]];
}

- (NSArray<IPCShoppingCartItem *>*)valueCardCartItems{
    return [self.itemList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject glasses] filterType] == IPCTopFilterTypeCard;
    }]];
}


- (NSArray<IPCShoppingCartItem *>*)selectCartItems{
    return [[self itemList] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject selected] && [[evaluatedObject glasses] filterType] != IPCTopFilterTypeCard;
    }]];
}

- (NSArray<IPCShoppingCartItem *>*)selectValueCardCartItems{
    return [self.itemList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject glasses] filterType] == IPCTopFilterTypeCard;
    }]];
}

- (NSArray<IPCShoppingCartItem *> *)selectPayCartItems{
    if ([self isExistValueCard]) {
        return [self selectValueCardCartItems];
    }
    return [self selectCartItems];
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

- (IPCShoppingCartItem *)selectedPayItemAtIndex:(NSInteger)index
{
    if ([self isExistValueCard]) {
        return [self selectValueCardCartItems][index];
    }
    return [self selectCartItems][index];
}

- (IPCShoppingCartItem *)selectedNormalSelltemAtIndex:(NSInteger)index
{
    return [self selectCartItems][index];
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


- (void)addValueCard:(IPCGlasses *)glass{
    [self addGlasses:glass Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil ContactID:nil IsOpenBooking:NO Count:1];
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
        item = [[IPCShoppingCartItem alloc]init];
        if (glasses.isBatch || ([glasses filterType] == IPCTopFilterTypeAccessory && glasses.solutionType) || ([glasses filterType] == IPCTopFilterTypeContactLenses && glasses.stock == 0))
        {
            item.batchSph = sph;
            item.bacthCyl = cyl;
            item.contactDegree = contactDegree;
            item.batchReadingDegree = readingDegree;
            item.kindNum = kindNum;
            item.batchNum = batchNum;
            item.validityDate = date;
            item.contactLensID = contactID;
            item.isPreSell = isOpenBooking;
        }
        item.glasses = glasses;
        item.count   = count;
        [self.itemList addObject:item];
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

- (void)removeAllValueCardCartItem{
    for (IPCShoppingCartItem *ci in [[IPCShoppingCart sharedCart] selectValueCardCartItems])
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


/**
 * Judge  Filter Type
 */
- (BOOL)isExistValueCard{
    __block BOOL isExist = NO;
    [self.itemList enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.glasses filterType] == IPCTopFilterTypeCard) {
            isExist = YES;
        }
    }];
    return isExist;
}

- (void)clearAllItemPoint{
    [[self selectPayCartItems] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isChoosePoint = NO;
        obj.pointValue = 0;
    }];
}

- (BOOL)judgeZeroPointValue{
    __block BOOL isZero = NO;
    [[self selectPayCartItems] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isChoosePoint) {
            obj.pointValue = 0;
            isZero = YES;
        }
    }];
    return isZero;
}


- (NSInteger)totalUsedPoint{
    __block NSInteger   totoalPoint = 0;
    [[self selectPayCartItems] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isChoosePoint) {
            totoalPoint += obj.pointValue * obj.count;
        }
    }];
    return totoalPoint;
}

- (BOOL)isHaveUsedPoint{
    __block BOOL isHave = NO;
    [[self selectPayCartItems] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isChoosePoint) {
            isHave = YES;
        }
    }];
    return isHave;
}




@end
