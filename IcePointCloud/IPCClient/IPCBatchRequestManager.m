//
//  IPCBatchRequestManager.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCBatchRequestManager.h"

@implementation IPCBatchRequestManager


+ (void)queryBatchLensProductsStockWithLensID:(NSString *)lenID
                                 SuccessBlock:(void (^)(id responseValue))success
                                 FailureBlock:(void (^)(NSError * error))failure
{
    NSString * lensID = [lenID substringFromIndex:[lenID rangeOfString:@"-"].location + 1];
    [self postRequest:lensID RequestMethod:@"batchAdmin.getBatchLenInventory"  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryBatchReadingProductsStockWithLensID:(NSString *)lenID
                                    SuccessBlock:(void (^)(id responseValue))success
                                    FailureBlock:(void (^)(NSError * error))failure
{
    NSString * lensID = [lenID substringFromIndex:[lenID rangeOfString:@"-"].location + 1];
    [self postRequest:lensID RequestMethod:@"batchAdmin.getBatchReadingGlassesInventory"  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryBatchContactProductsStockWithLensID:(NSString *)lenID
                                    SuccessBlock:(void (^)(id responseValue))success
                                    FailureBlock:(void (^)(NSError * error))failure
{
    NSString * lensID = [lenID substringFromIndex:[lenID rangeOfString:@"-"].location + 1];
    [self postRequest:lensID RequestMethod:@"batchAdmin.getBatchContactLensInventory"  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryContactGlassBatchSpecification:(NSArray *)contactLensID
                               SuccessBlock:(void (^)(id responseValue))success
                               FailureBlock:(void (^)(NSError *error))failure
{
    NSString * contactLens = [contactLensID componentsJoinedByString:@","];
    [self postRequest:contactLens RequestMethod:@"batchAdmin.getBatchContactLensInventoryDetailsByContactLensIds"  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryAccessoryBatchSpecification:(NSString *)lenID
                            SuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure
{
    NSString * lensID = [lenID substringFromIndex:[lenID rangeOfString:@"-"].location + 1];
    [self postRequest:lensID RequestMethod:@"batchAdmin.getContactSolutionDetailsWithProdIdForPos"  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


@end
