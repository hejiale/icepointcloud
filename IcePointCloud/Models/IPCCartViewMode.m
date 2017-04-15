//
//  IPCCartViewMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCartViewMode.h"


@implementation IPCCartViewMode

- (void)reloadContactLensStock{
    __block NSMutableArray<NSString *> * batchIDs = [[NSMutableArray alloc]init];
    [[[IPCShoppingCart sharedCart] itemList] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (([obj.glasses filterType] == IPCTopFilterTypeContactLenses && obj.glasses.isBatch) && !obj.isPreSell)
            [batchIDs addObject:obj.contactLensID];
    }];
    if ([batchIDs count]) {
        [self  queryContactLensStock:batchIDs];
    }
}

- (NSMutableArray<IPCContactLenSpecList *> *)contactSpecificationArray{
    if (!_contactSpecificationArray)
        _contactSpecificationArray = [[NSMutableArray alloc]init];
    return _contactSpecificationArray;
}

/**
 *  Judge contact lenses in the inventory
 *
 *  @param cartItem
 *
 *  @return
 */
- (BOOL)judgeContactLensStock:(IPCShoppingCartItem *)cartItem
{
    __block BOOL hasStock = NO;
    
    [self.contactSpecificationArray enumerateObjectsUsingBlock:^(IPCContactLenSpecList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.contactLensID isEqualToString:cartItem.contactLensID] && [obj.degree isEqualToString:cartItem.contactDegree]) {
            [obj.parameterList enumerateObjectsUsingBlock:^(IPCContactLenSpec * _Nonnull parameter, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([parameter.batchNumber isEqualToString:cartItem.batchNum] && [parameter.approvalNumber isEqualToString:cartItem.kindNum] && [parameter.expireDate isEqualToString:cartItem.validityDate]) {
                    if (cartItem.count >= parameter.bizStock) {
                        hasStock = YES;
                    }
                    *stop = YES;
                }
            }];
        }
    }];
    
    return hasStock;
}

/**
 *  Judgment of the currently selected shopping
 *
 *  @return
 */
- (BOOL)shoppingCartIsEmpty
{
    return [[IPCShoppingCart sharedCart] selectedItemsCount] == 0;
}


- (BOOL)judgeCartItemSelectState
{
    __block NSInteger selectCount = 0;
    
    [[[IPCShoppingCart sharedCart]itemList] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            selectCount++;
        }
    }];
    
    if (selectCount > 0) {
        if (selectCount == [[IPCShoppingCart sharedCart] itemsCount]) {
            return YES;
        }
    }
    return NO;
}


- (void)changeAllCartItemSelected:(BOOL)isSelected{
    for (int i = 0; i < [[IPCShoppingCart sharedCart] itemsCount]; i++) {
        IPCShoppingCartItem *ci = [[IPCShoppingCart sharedCart] itemAtIndex:i];
        ci.selected = isSelected;
    }
}

//Get Accessory Cart Stock
- (BOOL)accessoryCartStock:(IPCShoppingCartItem *)cartItem
{
    __block BOOL hasStock = YES;
    
    [self.accessorySpecification.parameterList enumerateObjectsUsingBlock:^(IPCAccessoryBatchNum * _Nonnull batchNumMode, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([batchNumMode.batchNumber isEqualToString:cartItem.batchNum]) {
            [batchNumMode.kindNumArray enumerateObjectsUsingBlock:^(IPCAccessoryKindNum * _Nonnull kindNumMode, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([kindNumMode.kindNum isEqualToString:cartItem.kindNum]) {
                    [kindNumMode.expireDateArray enumerateObjectsUsingBlock:^(IPCAccessoryExpireDate * _Nonnull dateMode, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([dateMode.expireDate isEqualToString:cartItem.validityDate]) {
                            if (dateMode.stock <= cartItem.count) {
                                hasStock = NO;
                            }
                            *stop = YES;
                        }
                    }];
                }
            }];
        }
    }];
    return hasStock;
}
#pragma mark //Request Data
- (void)queryContactLensStock:(NSArray *)contactIDs
{
    [self.contactSpecificationArray  removeAllObjects];
    
    [IPCBatchRequestManager queryContactGlassBatchSpecification:contactIDs SuccessBlock:^(id responseValue) {
        [contactIDs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IPCContactLenSpecList * contactSpecification = [[IPCContactLenSpecList alloc]initWithResponseObject:responseValue ContactLensID:obj];
            [self.contactSpecificationArray addObject:contactSpecification];
        }];
        [IPCCustomUI hiden];
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.domain];
    }];
}


- (void)queryAccessoryStock:(IPCShoppingCartItem *)cartItem Complete:(void(^)(BOOL hasStock))complete
{
    [IPCBatchRequestManager queryAccessoryBatchSpecification:cartItem.glasses.glassesID
                                                SuccessBlock:^(id responseValue)
     {
         _accessorySpecification = [[IPCAccessorySpecList alloc]initWithResponseObject:responseValue];
         if (complete) {
             complete([self accessoryCartStock:cartItem]);
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}


- (void)offerOrderWithCashBlock:(void(^)())cash EbuyBlock:(void(^)(IPCOrder *result))ebuy Failed:(void(^)())failed
{
    [IPCCustomUI show];
    [IPCPayOrderRequestManager offerOrderWithRequestCustomerID:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerID
                                                    OpometryID:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.optometryID
                                                     AddressID:[IPCCurrentCustomerOpometry sharedManager].currentAddress.addressID
                                                   OrderRemark:nil
                                                       PayType:nil
                                                   TotalAmount:[[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]
                                                 PrepaidAmount:0
                                                 DiscountPrice:0
                                                     EmployeID:nil
                                                  SuccessBlock:^(id responseValue)
     {
//         if ([[IPCPayOrderMode sharedManager].payStyleName isEqualToString:@"CASH"] || [[IPCPayOrderMode sharedManager].payStyleName isEqualToString:@"CARD"])  {
//             if (cash)
//                 cash();
//             [IPCCustomUI showSuccess:@"请前去现金或刷卡支付订单!"];
//         }else{
//             IPCOrder *result = [IPCOrder mj_objectWithKeyValues:responseValue];
//             if (result)
//                 if (ebuy)
//                     ebuy(result);
             [IPCCustomUI hiden];
//         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
//         if (failed) {
//             failed();
//         }
     }];
}

@end
