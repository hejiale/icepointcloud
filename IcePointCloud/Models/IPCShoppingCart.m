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

// private methods
- (NSMutableArray<IPCShoppingCartItem *> *)itemList
{
    if (!_itemList) {
        _itemList = [NSMutableArray new];
    }
    return _itemList;
}

/**
 *  The shopping cart number
 *
 */
- (NSInteger)itemsCount
{
    return self.itemList.count;
}

- (NSInteger)selectItemsCount
{
    return [self selectCartItems].count;
}

- (NSInteger)allGlassesCount
{
    NSInteger count = 0;
    for (IPCShoppingCartItem *ci in self.itemList) {
        count += ci.glassCount;
    }
    return count;
}

- (NSUInteger)itemsCount:(IPCShoppingCartItem *)cartItem{
    __block NSInteger count = 0;
    
    for (IPCShoppingCartItem * item in self.itemList) {
        if ([item isEqual:cartItem]) {
            count = item.glassCount;
        }
    }
    return count;
}

/**
 *  Shopping cart price calculation
 *
 */
- (double)allGlassesTotalPrice
{
    double price = 0;
    for (IPCShoppingCartItem *ci in self.itemList) {
        price += ci.totalPrice;
    }
    return price;
}


#pragma mark //CartItem
- (NSArray<IPCShoppingCartItem *>*)selectCartItems{
    return [[self itemList] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject selected];
    }]];
}

/**
 *  Specify a shopping cart information
 */
- (IPCShoppingCartItem *)itemAtIndex:(NSInteger)index
{
    return self.itemList[index];
}

/**
 *  Add a shopping cart
 *
 */
- (void)plusItem:(IPCShoppingCartItem *)cartItem{
    if (cartItem){
        cartItem.glassCount++;
    }
    [self postChangedNotification];
}

- (void)plusGlass:(IPCGlasses *)glass{
    if (glass) {
        [self addGlasses:glass Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil  Count:1];
    }
}


- (void)addLensWithGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:nil ContactDegree:nil  Count:count];
}

- (void)addReadingLensWithGlasses:(IPCGlasses *)glasses ReadingDegree:(NSString *)readingDegree  Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:nil Cyl:nil ReadingDegree:readingDegree ContactDegree:nil Count:count];
}

- (void)addContactLensWithGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl Count:(NSInteger)count
{
    [self addGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:nil ContactDegree:nil Count:count];
}

- (void)addGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree Count:(NSInteger)count
{
    if (count <= 0)return;
    
    IPCShoppingCartItem *item = nil;
    if (glasses.isBatch)
    {
        item = [self batchItemForGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:readingDegree ContactDegree:contactDegree];
    }else{
        item = [self normalItemForGlasses:glasses];
    }
    
    if (item) {
        item.glassCount += count;
    } else {
        item = [[IPCShoppingCartItem alloc]init];
        if (glasses.isBatch)
        {
            item.batchSph = sph;
            item.bacthCyl = cyl;
            item.batchReadingDegree = readingDegree;
        }
        item.glasses = glasses;
        item.glassCount   = count;
        item.selected = YES;
        [self.itemList addObject:item];
    }
    [self postChangedNotification];
    [self requestTradeOrExchangeStatus];
}


/**
 *  Remove the corresponding shopping goods
 *
 */
- (void)removeGlasses:(IPCGlasses *)glasse{
    [self removeGlasses:glasse Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil];
}


- (void)removeGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree
{
    IPCShoppingCartItem *item = nil;
    
    if (glasses.isBatch) {
        item = [self batchItemForGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:readingDegree ContactDegree:contactDegree];
    }else{
        item = [self normalItemForGlasses:glasses];
    }
    
    if (item) {
        item.glassCount--;
        if (item.glassCount == 0) {
            [self.itemList removeObject:item];
        }
    }
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
        cartItem.glassCount--;
        if (cartItem.glassCount == 0) {
            [self.itemList removeObject:cartItem];
        }
    }
    [self postChangedNotification];
}

/**
 *  The same commodity type number
 *
 */
- (NSInteger)singleGlassesCount:(IPCGlasses *)glasses{
    __block NSInteger itemCount = 0;
    
    for (IPCShoppingCartItem * item in self.itemList) {
        if ([item.glasses.glassesID isEqualToString:glasses.glassesID]) {
            itemCount += item.glassCount;
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
    return [self batchItemForGlasses:glasses Sph:sph Cyl:cyl ReadingDegree:nil ContactDegree:nil];
}

- (IPCShoppingCartItem *)readingLensForGlasses:(IPCGlasses *)glasses ReadingDegree:(NSString *)readingDegree
{
    return [self batchItemForGlasses:glasses Sph:nil Cyl:nil ReadingDegree:readingDegree ContactDegree:nil];
}

- (IPCShoppingCartItem *)contactLensForGlasses:(IPCGlasses *)glasses  ContactDegree:(NSString *)contactDegree
{
    return [self batchItemForGlasses:glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:contactDegree];
}


- (IPCShoppingCartItem *)batchItemForGlasses:(IPCGlasses *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl  ReadingDegree:(NSString *)readingDegree ContactDegree:(NSString *)contactDegree
{
    for (IPCShoppingCartItem *ci in self.itemList)
        if (([ci.glasses.glassesID isEqualToString:glasses.glassesID])){
            if ([glasses filterType] == IPCTopFilterTypeLens || [glasses filterType] == IPCTopFilterTypeContactLenses) {
                if ([cyl isEqualToString:ci.bacthCyl] && [sph isEqualToString:ci.batchSph])
                    return ci;
            }else if ([glasses filterType] == IPCTopFilterTypeReadingGlass){
                if ([readingDegree isEqualToString:ci.batchReadingDegree])
                    return ci;
            }
        }
    return nil;
}

- (void)postChangedNotification
{
    [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCNotificationShoppingCartChanged object:nil];
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

- (NSInteger)totalUsedPoint{
    __block NSInteger   totoalPoint = 0;
    [self.itemList enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isChoosePoint) {
            totoalPoint += obj.pointValue * obj.glassCount;
        }
    }];
    return totoalPoint;
}

- (double)totalUsedPointPrice{
    __block double   totoalPointPrice = 0;
    [self.itemList enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isChoosePoint) {
            totoalPointPrice += obj.pointPrice;
        }
    }];
    return totoalPointPrice;
}

- (BOOL)isHaveUsedPoint{
    __block BOOL isHave = NO;
    [self.itemList enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isChoosePoint) {
            isHave = YES;
        }
    }];
    return isHave;
}


- (void)requestTradeOrExchangeStatus
{
    [IPCPayOrderRequestManager getStatusTradeOrExchangeWithSuccessBlock:^(id responseValue) {
        [IPCPayOrderManager sharedManager].isTrade = YES;
    } FailureBlock:^(NSError *error) {
        if ([error code] != NSURLErrorCancelled) {
            [IPCCommonUI showError:@"查询积分定制规则失败！"];
        }
        
    }];
}

@end
