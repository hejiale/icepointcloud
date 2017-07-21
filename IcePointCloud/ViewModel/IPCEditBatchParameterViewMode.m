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


- (void)queryContactLensStockRequest
{
    [IPCBatchRequestManager queryBatchContactProductsStockWithLensID:[self.currentGlass glassId]
                                                        SuccessBlock:^(id responseValue)
    {
        _batchParameterList = [[IPCBatchParameterList alloc]initWithResponseObject:responseValue];
        if (self.UpdateBlock) {
            self.UpdateBlock();
        }
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.domain];
        if (self.UpdateBlock) {
            self.UpdateBlock();
        }
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
    
    [self.batchParameterList.parameterList enumerateObjectsUsingBlock:^(BatchParameterObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cartItem.contactLensID isEqualToString:obj.batchID] && [cartItem.contactDegree isEqualToString:obj.degree]) {
            lensStock = obj.bizStock;
            *stop = YES;
        }
    }];
    return lensStock;
}


@end
