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
        if ([obj.glasses filterType] == IPCTopFilterTypeContactLenses && obj.glasses.isBatch)
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
//- (BOOL)judgeContactLensStock:(IPCShoppingCartItem *)cartItem
//{
//    __block BOOL hasStock = NO;
//    
//    [self.contactSpecificationArray enumerateObjectsUsingBlock:^(IPCContactLenSpecList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.contactLensID isEqualToString:cartItem.contactLensID] && [obj.degree isEqualToString:cartItem.contactDegree]) {
//            [obj.parameterList enumerateObjectsUsingBlock:^(IPCContactLenSpec * _Nonnull parameter, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([parameter.batchNumber isEqualToString:cartItem.batchNum] && [parameter.approvalNumber isEqualToString:cartItem.kindNum] && [parameter.expireDate isEqualToString:cartItem.validityDate]) {
//                    if (cartItem.glassCount >= parameter.bizStock) {
//                        hasStock = YES;
//                    }
//                    *stop = YES;
//                }
//            }];
//        }
//    }];
//    
//    return hasStock;
//}

/**
 *  Judgment of the currently selected shopping
 *
 *  @return
 */
- (BOOL)shoppingCartIsEmpty
{
    return [[IPCShoppingCart sharedCart] selectItemsCount] == 0;
}


- (BOOL)judgeCartItemSelectState
{
    __block NSInteger selectCount = 0;
    
    [[[IPCShoppingCart sharedCart] itemList] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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


- (void)requestTradeOrExchangeStatus:(void(^)())complete
{
    [IPCPayOrderRequestManager getStatusTradeOrExchangeWithSuccessBlock:^(id responseValue) {
        [IPCPayOrderManager sharedManager].isTrade = [responseValue boolValue];
        if (complete) {
            complete();
        }
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.domain];
    }];
}

@end
