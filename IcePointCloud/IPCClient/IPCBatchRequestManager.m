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
    [self loadRequest:lensID RequestMethod:@"batchAdmin.getBatchLenInventory" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryBatchReadingProductsStockWithLensID:(NSString *)lenID
                                    SuccessBlock:(void (^)(id responseValue))success
                                    FailureBlock:(void (^)(NSError * error))failure
{
    NSString * lensID = [lenID substringFromIndex:[lenID rangeOfString:@"-"].location + 1];
    [self loadRequest:lensID RequestMethod:@"batchAdmin.getBatchReadingGlassesInventory" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryBatchContactProductsStockWithLensID:(NSString *)lenID
                                    SuccessBlock:(void (^)(id responseValue))success
                                    FailureBlock:(void (^)(NSError * error))failure
{
    NSString * lensID = [lenID substringFromIndex:[lenID rangeOfString:@"-"].location + 1];
    [self loadRequest:lensID RequestMethod:@"batchAdmin.getBatchContactLensInventory" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryContactGlassBatchSpecification:(NSArray *)contactLensID
                               SuccessBlock:(void (^)(id responseValue))success
                               FailureBlock:(void (^)(NSError *error))failure
{
    NSString * contactLens = [contactLensID componentsJoinedByString:@","];
    [self loadRequest:contactLens RequestMethod:@"batchAdmin.getBatchContactLensInventoryDetailsByContactLensIds" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryAccessoryBatchSpecification:(NSString *)lenID
                            SuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure
{
    NSString * lensID = [lenID substringFromIndex:[lenID rangeOfString:@"-"].location + 1];
    [self loadRequest:lensID RequestMethod:@"batchAdmin.getContactSolutionDetailsWithProdIdForPos" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


@end
