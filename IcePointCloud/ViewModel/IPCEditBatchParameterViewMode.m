//
//  IPCEditBatchParameterMode.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCEditBatchParameterViewMode.h"

@interface IPCEditBatchParameterViewMode()

@property (copy, nonatomic) void(^UpdateBlock)();

@end

@implementation IPCEditBatchParameterViewMode

- (instancetype)initWithGlasses:(IPCGlasses *)glass UpdateUI:(void(^)())update
{
    self = [super init];
    if (self) {
        self.currentGlass = glass;
        self.UpdateBlock = update;
    }
    return self;
}

- (NSMutableArray<IPCContactLenSpecList *> *)contactSpecificationArray{
    if (!_contactSpecificationArray)
        _contactSpecificationArray = [[NSMutableArray alloc]init];
    return _contactSpecificationArray;
}

#pragma mark //Network Request
- (void)queryBatchStockRequest{
    [IPCBatchRequestManager queryBatchLensProductsStockWithLensID:[self.currentGlass glassId]
                                                     SuccessBlock:^(id responseValue)
     {
         _batchParameterList = [[IPCBatchParameterList alloc]initWithResponseObject:responseValue];
         if (self.UpdateBlock) {
             self.UpdateBlock();
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

- (void)queryBatchReadingDegreeRequest{
    [IPCBatchRequestManager queryBatchReadingProductsStockWithLensID:[self.currentGlass glassId]
                                                        SuccessBlock:^(id responseValue)
     {
         _batchParameterList = [[IPCBatchParameterList alloc]initWithResponseObject:responseValue];
         if (self.UpdateBlock) {
             self.UpdateBlock();
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}


- (void)getContactLensSpecification
{
    __block NSMutableArray<NSString *> * contactLensIDs = [[NSMutableArray alloc]init];
    if (self.currentGlass.stock > 0) {
        [[[IPCShoppingCart sharedCart] batchParameterList:self.currentGlass] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (! [contactLensIDs containsObject:obj.contactLensID]){
                [contactLensIDs addObject:obj.contactLensID];
            }
        }];
    }
    
    if (contactLensIDs.count) {
        [IPCBatchRequestManager queryContactGlassBatchSpecification:contactLensIDs SuccessBlock:^(id responseValue) {
            [contactLensIDs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCContactLenSpecList * _contactSpecificationArray = [[IPCContactLenSpecList alloc]initWithResponseObject:responseValue ContactLensID:obj];
                [self.contactSpecificationArray addObject:_contactSpecificationArray];
            }];
            if (self.UpdateBlock) {
                self.UpdateBlock();
            }
        } FailureBlock:^(NSError *error) {
            [IPCCustomUI showError:error.domain];
        }];
    }else{
        if (self.UpdateBlock) {
            self.UpdateBlock();
        }
    }
}

- (void)queryAccessoryStock{
    [IPCBatchRequestManager queryAccessoryBatchSpecification:[self.currentGlass glassId]
                                                SuccessBlock:^(id responseValue)
     {
         _accessorySpecification = [[IPCAccessorySpecList alloc]initWithResponseObject:responseValue];
         if (self.UpdateBlock) {
             self.UpdateBlock();
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

#pragma mark //To obtain the corresponding  lens specifications of the inventory
- (NSInteger)queryLensStock:(IPCShoppingCartItem *)cartItem{
    __block NSInteger lensStock = 0;
    
    [self.batchParameterList.parameterList enumerateObjectsUsingBlock:^(BatchParameterObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.sph isEqualToString:cartItem.batchSph] && [obj.cyl isEqualToString:cartItem.bacthCyl]) {
            lensStock = obj.bizStock;
            *stop = YES;
        }
    }];
    return lensStock;
}


- (NSInteger)queryReadingLensStock:(IPCShoppingCartItem *)cartItem{
    __block NSInteger lensStock = 0;
    
    [self.batchParameterList.parameterList enumerateObjectsUsingBlock:^(BatchParameterObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.degree isEqualToString:cartItem.batchReadingDegree]) {
            lensStock = obj.bizStock;
            *stop = YES;
        }
    }];
    return lensStock;
}


- (NSInteger)queryContactLensStock:(IPCShoppingCartItem *)cartItem{
    __block NSInteger lensStock = 0;
    
    [self.contactSpecificationArray enumerateObjectsUsingBlock:^(IPCContactLenSpecList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cartItem.contactLensID isEqualToString:obj.contactLensID] && [cartItem.contactDegree isEqualToString:obj.degree]) {
            [obj.parameterList enumerateObjectsUsingBlock:^(IPCContactLenSpec * _Nonnull specification, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([specification.batchNumber  isEqualToString:cartItem.batchNum] && [specification.approvalNumber isEqualToString:cartItem.kindNum] && [specification.expireDate isEqualToString:cartItem.validityDate]) {
                    lensStock = specification.bizStock;
                    *stop = YES;
                }
            }];
        }
    }];
    return lensStock;
}

- (NSInteger)queryAccessoryStock:(IPCShoppingCartItem *)cartItem{
    __block NSInteger lensStock = 0;
    [self.accessorySpecification.parameterList enumerateObjectsUsingBlock:^(IPCAccessoryBatchNum * _Nonnull batchNumMode, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([batchNumMode.batchNumber isEqualToString:cartItem.batchNum]) {
            [batchNumMode.kindNumArray enumerateObjectsUsingBlock:^(IPCAccessoryKindNum * _Nonnull kindNumMode, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([kindNumMode.kindNum isEqualToString:cartItem.kindNum]) {
                    [kindNumMode.expireDateArray enumerateObjectsUsingBlock:^(IPCAccessoryExpireDate * _Nonnull dateMode, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([dateMode.expireDate isEqualToString:cartItem.validityDate]) {
                            lensStock = dateMode.stock;
                            *stop = YES;
                        }
                    }];
                }
            }];
        }
    }];
    return lensStock;
}

@end
